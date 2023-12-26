variable "db" {
  description = "firestore db"
  type = object(
    {
      name             = string
      type             = string
      location_id      = string
      concurrency_mode = optional(string)
      app_engine = optional(
        object(
          {
            integration_mode = optional(string, "DISABLED")
            create           = optional(bool, false)
          },
        )
      )
      delete_protection_state = optional(string, "DELETE_PROTECTION_DISABLED")
      deletion_policy         = optional(string, "ABANDON")
    }
  )
}

variable "datastore_indices" {
  description = "datastore indices definition"
  type = map(
    object(
      {
        kind = string
        properties = list(
          object(
            {
              name      = string
              direction = string
            }
          )
        )
      }
    )
  )
  default = {}
}
