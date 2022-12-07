output "do_ssh_key_id" {
  value = module.base.do_ssh_key_id
}

output "droplet_user_data" {
  value = module.base.droplet_user_data
}

output "do_project_id" {
  value = module.base.do_project_id
}

output "domain_name" {
  value = module.base.domain_name
}

output "gh_repo_name" {
  value = module.base.gh_repo_name
}

output "ssh_key" {
  value     = module.base.ssh_key.private_key_openssh
  sensitive = true
}
