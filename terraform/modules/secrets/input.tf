variable "secrets" {
  type = map(
    object(
      {
        name                      = string
        secrets_to_import         = optional(list(string), [])
        secrets_data              = optional(map(string), {})
        secrets_from_other_secret = optional(string)
        base64_secrets            = optional(bool, false)
        annotations               = optional(map(string))
        labels                    = optional(map(string))
        gcp = optional(
          object(
            {
              enabled = bool
              iam_roles = optional(
                list(
                  object(
                    {
                      role    = string
                      members = list(string)
                    }
                  )
                )
              )
              kms_key = optional(string)
            }
          ),
          {
            enabled   = false
            iam_roles = []
            kms_key   = null
          }
        )
        k8s = optional(
          object(
            {
              enabled   = bool
              namespace = string
            }
          ),
          {
            enabled   = false
            namespace = "default"
          }
        )
      }
    )
  )
  description = "Secret's that should be created"
  default     = {}
}
