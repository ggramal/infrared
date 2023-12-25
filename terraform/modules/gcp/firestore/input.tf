variable "db" {
  description = "firestore db "
  type = object(
    {
      name                        = string
      type                        = string
      location_id                 = string
      concurrency_mode            = optional(string)
      app_engine_integration_mode = optional(string, "DISABLED")
      delete_protection_state     = optional(string, "DELETE_PROTECTION_STATE_UNSPECIFIED")
      deletion_policy             = optional(string, "ABANDON")
    }
  )
}
