locals {
  user = {
    name               = var.user.name
    project_id         = var.user.project_id
    auth_database_name = var.user.auth_database_name
    roles = [
      for role in var.user.roles :
      {
        role_name     = role.role_name
        database_name = role.database_name
      }
    ]
  }
}

variable "user" {
  type        = any
  description = "User definition"
}
