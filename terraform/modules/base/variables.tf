variable "ssh_key_name" {
  description = "Name of the `digitalocean_ssh_key`."
  type        = string
}

variable "droplet_user" {
  description = "Name of the user created for the `digitalocean_droplet`."
  type        = string
}

variable "docker_compose_version" {
  description = "Docker compose version string."
  type        = string
}

variable "domain_name" {
  description = "Domain pointing to DigitalOcean name servers."
  type        = string
}

variable "do_project_name" {
  description = "The name of the `digitalocean_project`."
  type        = string
}

variable "do_project_description" {
  description = "Description of the `digitalocean_project`."
  type        = string
}

variable "gh_repo_name" {
  description = "Name of the `github_repository`."
  type        = string
}

variable "tf_api_token" {
  description = "Token used to authenticate with Terraform Cloud/Enterprise."
  type        = string
}
