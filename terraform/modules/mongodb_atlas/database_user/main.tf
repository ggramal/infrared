resource "mongodbatlas_database_user" "this" {
  username           = local.user.name
  password           = random_string.password.result
  project_id         = local.user.project_id
  auth_database_name = local.user.auth_database_name

  dynamic "roles" {
    for_each = local.user.roles
    content {
      role_name     = roles.value.role_name
      database_name = roles.value.database_name
    }
  }
}

resource "random_string" "password" {
  length  = 32
  special = false
}
