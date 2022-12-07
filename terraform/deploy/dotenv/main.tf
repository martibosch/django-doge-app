data "tfe_workspace" "stage" {
  name         = "${var.project_slug}-stage"
  organization = var.tfc_org_name
}

data "tfe_workspace" "prod" {
  name         = "${var.project_slug}-prod"
  organization = var.tfc_org_name
}

resource "tfe_variable" "env_file_map_stage" {
  key = "env_file_map"
  # env files are kept out of version control, so not all users will have them locally.
  # Therefore, the idea is that the first user (who has the env files locally) creates
  # this variable on terraform cloud, and this remains unchanged. In case the variable
  # actually needs a change, it can be done via
  # `terraform destroy --target tfe_variable.env_file_map_stage` followed by
  # `terraform apply`
  value = jsonencode({
    for key, filepath in var.env_file_map_stage :
    key => filebase64(filepath)
  })
  category     = "terraform"
  workspace_id = data.tfe_workspace.stage.id
}

resource "tfe_variable" "env_file_map_prod" {
  key = "env_file_map"
  # env files are kept out of version control, so not all users will have them locally.
  # Therefore, the idea is that the first user (who has the env files locally) creates
  # this variable on terraform cloud, and this remains unchanged. In case the variable
  # actually needs a change, it can be done via
  # `terraform destroy --target tfe_variable.env_file_map_stage` followed by
  # `terraform apply`
  value = jsonencode({
    for key, filepath in var.env_file_map_prod :
    key => filebase64(filepath)
  })
  category     = "terraform"
  workspace_id = data.tfe_workspace.prod.id
}
