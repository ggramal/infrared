variable "vpc" {
  description = "Vpc description"
  type = object(
    {
      project_id = string
      self_link  = string
      name       = string
    }
  )
}

variable "peering_net" {
  description = "Peering information"
  type = object(
    {
      prefix_length = number
      description   = optional(string, "")
    }
  )
}
