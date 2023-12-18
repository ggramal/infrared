variable "external" {
  type = map(
    object(
      {
        external_name = string
        namespace     = optional(string, "default")
      }
    )
  )
}
