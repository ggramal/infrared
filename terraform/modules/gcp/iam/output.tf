output "service_accounts" {
  value = {
    for sa_name, sa_obj in module.service_accounts :
    sa_name => sa_obj.service_account
  }
}

output "custom_roles" {
  value = {
    for role_name, role_obj in module.custom_roles :
    role_name => role_obj.custom_role
  }
}
