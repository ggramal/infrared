variable "custom_roles" {
  type = map(
    object(
      {
        title       = string
        description = string
        permissions = list(string)
      }
    )
  )
}

variable "service_accounts" {
  type = map(
    object(
      {
        description = string
        roles       = optional(list(string))
        #service accounts can be treated
        #as gcp resources. So you can
        #grant service accounts to specific
        #iam entities
        sa_iam_bindings = optional(
          map(
            list(string)
          ),
          {}
        )
        generate_key = optional(bool, true)
      }
    )
  )
}

variable "roles" {
  type = map(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
}

variable "project_id" {
  type = string
}
