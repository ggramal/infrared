module "custom_roles" {
  source      = "./custom_role"
  for_each    = var.custom_roles
  name        = each.key
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions

}

module "roles" {
  source     = "./role"
  for_each   = var.roles
  project_id = var.project_id
  role       = each.value.role
  members    = each.value.members
}

module "service_accounts" {
  source          = "./service_account"
  for_each        = var.service_accounts
  project_id      = var.project_id
  name            = each.key
  description     = each.value.description
  roles           = each.value.roles
  sa_iam_bindings = each.value.sa_iam_bindings
  generate_key    = each.value.generate_key
}

