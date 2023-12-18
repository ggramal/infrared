variable "namespaces" {
  type = map(
    object(
      {
        annotations = optional(map(string), {})
        labels      = optional(map(string), {})
        name        = string
      }
    )
  )
}
