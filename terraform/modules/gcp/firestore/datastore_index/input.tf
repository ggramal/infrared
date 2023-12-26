variable "kind" {
  description = "The entity kind which the index applies to."
}

variable "properties" {
  description = "An ordered list of properties to index on"
  type = list(
    object(
      {
        name      = string
        direction = string
      }
    )
  )
}
