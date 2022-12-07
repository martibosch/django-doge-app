terraform {
  required_providers {
    tfe = {
      version = "~> 0.35.0"
    }
  }
}

# four options to auth to terraform cloud:
# a) token arg in the provider block
# b) TFE_TOKEN env variable
# c) `terraform login` in the CLI
# d) set the credentials block in the CLI config file
# we choose a) given https://github.com/hashicorp/terraform-provider-tfe/issues/102
provider "tfe" {
  token = var.tf_api_token
}
