module "base" {
  source = "github.com/martibosch/django-doge-app//terraform/modules/base"

  ssh_key_name           = var.ssh_key_name
  droplet_user           = var.droplet_user
  docker_compose_version = var.docker_compose_version
  domain_name            = var.domain_name
  do_project_name        = var.do_project_name
  do_project_description = var.do_project_description
  gh_repo_name           = var.gh_repo_name
  tf_api_token           = var.tf_api_token
}
