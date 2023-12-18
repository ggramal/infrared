locals {
  all_roles = merge(
    var.rw_roles,
    var.ro_roles,
    var.owner_roles,
    var.system_users,
    var.app_users,
    var.system_roles,
    var.external_users,
  )
}


variable "rw_roles" {
  description = "Databases roles with read & write permissions"
  type = map(
    object(
      {
        grant_to            = list(string)
        skip_drop_role      = optional(bool, true)
        skip_reassign_owned = optional(bool, true)
      }
    )
  )
}

variable "ro_roles" {
  description = "Database roles with read only permissions"
  type = map(
    object(
      {
        grant_to            = list(string)
        skip_drop_role      = optional(bool, true)
        skip_reassign_owned = optional(bool, true)
      }
    )
  )
}

variable "owner_roles" {
  description = "Database owner roles"
  type = map(
    object(
      {
        grant_to            = list(string)
        skip_drop_role      = optional(bool, true)
        skip_reassign_owned = optional(bool, true)
      }
    )
  )
}

variable "system_roles" {
  description = "Postgres system roles"
  type = map(
    object(
      {
        grant_to = list(string)
      }
    )
  )
}

variable "external_users" {
  description = "Postgres user roles not created in terraform"
  type = map(
    object(
      {
        grant_to = list(string)
      }
    )
  )
  default = {}
}

variable "system_users" {
  description = "Postgres system roles like vault,postgres etc"
  type = map(
    object(
      {
        grant_to        = list(string)
        password        = optional(string)
        create_database = optional(bool, false)
      }
    )
  )
}

variable "app_users" {
  description = "Application users"
  type = map(
    object(
      {
        grant_to = list(string)
        password = optional(string)
      }
    )
  )
}
