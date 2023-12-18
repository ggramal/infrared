locals {
  potential_owners = distinct(
    flatten(
      [
        for k, v in var.owner_roles :
        v.grant_to
      ]
    )
  )
}

variable "database" {
  description = "Database definition"
  type = object(
    {
      name              = string
      owner             = string
      connection_limit  = number
      allow_connections = bool
      template          = string
      collate           = string
      ctype             = string

    }
  )
}

variable "schemas" {
  description = "Database schemas definition"
  type = map(
    object(
      {
        owner = string
      }
    )
  )
}

variable "ro_roles" {
  description = "Database roles with ro access"
  type = map(
    object(
      {
        grant_to = list(string)
      }
    )
  )
  default = {}
}

variable "rw_roles" {
  description = "Database roles with rw access"
  type = map(
    object(
      {
        grant_to = list(string)
      }
    )
  )
  default = {}
}

variable "owner_roles" {
  description = "Database roles with onwer access"
  type = map(
    object(
      {
        grant_to = list(string)
      }
    )
  )
  default = {}
}
variable "extensions" {
  type    = list(string)
  default = []
}
