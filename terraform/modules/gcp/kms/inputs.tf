variable "key_ring" {
  type = object(
    {
      name     = string
      location = string
    }
  )
}

variable "keys" {
  type = map(
    object(
      {
        name             = string
        rotation_period  = optional(string, "3153600000s")
        purpose          = optional(string, "ENCRYPT_DECRYPT")
        algorithm        = optional(string)
        protection_level = optional(string, "SOFTWARE")
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
      }
    )
  )
}
