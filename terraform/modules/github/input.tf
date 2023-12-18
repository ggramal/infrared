variable "repositories" {
  description = "Github repositories"
  type = map(
    object(
      {
        name = string
        org  = string
        deploy_keys = map(
          object(
            {
              name        = string
              public_key  = optional(string, "")
              private_key = optional(string, "")
              read_only   = bool
              create      = optional(bool, false)
            }
          )
        )
        secrets = optional(
          map(
            object(
              {
                name       = string
                text_value = string
              }
            )
          ), {}
        )
      }
    )
  )
}
