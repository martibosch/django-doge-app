########################################################################################

TERRAFORM_DIR := terraform
ENVS := stage prod
VARS_FILENAME := vars.tfvars
DEPLOY_DIR := $(TERRAFORM_DIR)/deploy
META_DIR := $(DEPLOY_DIR)/meta
DOTENV_DIR := $(DEPLOY_DIR)/dotenv
BASE_DIR := $(DEPLOY_DIR)/base
APP_DIR := $(DEPLOY_DIR)/app
ENV_DIR = $(APP_DIR)/$(ENV)
VARFILE_DIRS = $(META_DIR) $(DOTENV_DIR)
DEPLOY_DIRS = $(BASE_DIR) $(foreach ENV, $(ENVS), $(ENV_DIR))
WORKSPACE_DIRS = $(VARFILE_DIRS) $(DEPLOY_DIRS)
TARGET = $(notdir $(DIR))
NOARGS_COMMANDS := init fmt validate
COMMANDS := plan apply destroy

# noargs commands
define NOARGS_RULE
.PHONY: $(COMMAND)-$(TARGET)
$(COMMAND)-$(TARGET):
	terraform -chdir="./$(DIR)" $(COMMAND)
endef
$(foreach DIR, $(WORKSPACE_DIRS), $(foreach COMMAND, $(NOARGS_COMMANDS), \
	$(eval $(NOARGS_RULE))))

define NOARGS_ALL_RULE
.PHONY: $(COMMAND)-all
$(COMMAND)-all: $(foreach DIR, $(WORKSPACE_DIRS), $(COMMAND)-$(TARGET))
endef
$(foreach COMMAND, $(NOARGS_COMMANDS), $(eval $(NOARGS_ALL_RULE)))

define UPDATE_RULE
.PHONY: update-$(TARGET)
update-$(TARGET):
	terraform -chdir="./$(DIR)" get -update
endef
$(foreach DIR, $(WORKSPACE_DIRS), $(eval $(UPDATE_RULE)))

# plan/apply/destroy
## treat meta separatedly because of `-var-file`
define VARFILE_COMMAND_RULE
.PHONY: $(COMMAND)-$(TARGET)
$(COMMAND)-$(TARGET):
	terraform -chdir="./$(DIR)" $(COMMAND) -var-file=$(VARS_FILENAME) \
		$(TF_FLAGS)
endef
$(foreach DIR, $(VARFILE_DIRS), $(foreach COMMAND, $(COMMANDS), \
	$(eval $(VARFILE_COMMAND_RULE))))

define COMMAND_RULE
.PHONY: $(COMMAND)-$(TARGET)
$(COMMAND)-$(TARGET):
	terraform -chdir="./$(DIR)" $(COMMAND) $(TF_FLAGS)
endef
$(foreach DIR, $(DEPLOY_DIRS), $(foreach COMMAND, $(COMMANDS), \
	$(eval $(COMMAND_RULE))))

# clean state
define CLEAN_RULE
.PHONY: clean-$(TARGET)
clean-$(TARGET):
	find $(DIR) -type d -name ".terraform" -exec rm -rf {} +
endef
$(foreach DIR, $(WORKSPACE_DIRS), $(eval $(CLEAN_RULE)))
.PHONY: clean-all
clean-all: $(foreach DIR, $(WORKSPACE_DIRS), clean-$(TARGET))

# ssh
define SSH_RULE
.PHONY: ssh-$(ENV)
ssh-$(ENV):
	$(eval TMP_DIR := $(shell mktemp -d)/key)
	$(eval TMP_SSH_KEY_FILEPATH := $(TMP_DIR)/key)
	mkdir $(TMP_DIR)
	terraform -chdir="./$(BASE_DIR)" output -raw ssh_key > $(TMP_SSH_KEY_FILEPATH)
	chmod 600 $(TMP_SSH_KEY_FILEPATH)
	ssh $(SSH_FLAGS) -i $(TMP_SSH_KEY_FILEPATH) \
		ubuntu@$$(shell terraform -chdir="./$(ENV_DIR)" \
		output -raw droplet_host)
endef
$(foreach ENV, $(ENVS), $(eval $(SSH_RULE)))

# create repo
.PHONY: create-repo
create-repo:
	git init --initial-branch=main
	pre-commit install
	git add .
	SKIP=terraform_validate git commit -m "initial commit"
	gh repo create django-doge-app --public -s . --push -r origin \
		-d "Example Django app using the Doge workflow"
########################################################################################
