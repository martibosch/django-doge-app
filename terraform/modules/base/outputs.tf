output "do_ssh_key_id" {
  description = "ID of the `digitalocean_ssh_key`."
  value       = digitalocean_ssh_key.ssh_key.id
}

output "droplet_user_data" {
  description = "User data for the `digitalocean_droplet`."
  value       = data.template_file.cloud-init-yaml.rendered
}

output "domain_name" {
  description = "Name of the `digitalocean_domain`."
  value       = digitalocean_domain.domain.name
}

output "do_project_id" {
  description = "ID of the `digitalocean_project`."
  value       = digitalocean_project.do_project.id
}

output "gh_repo_name" {
  description = "Name of the `github_repository`."
  value       = data.github_repository.repo.name
}

output "ssh_key" {
  description = "Private key."
  value       = tls_private_key.ssh_key
}
