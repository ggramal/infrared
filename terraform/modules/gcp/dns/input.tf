variable "zone" {
  type = object(
    {
      name         = string
      dns_name     = string
      description  = optional(string, "Managed by Terraform")
      dnssec_state = optional(string, "on")
    }
  )
}

variable "records" {
  type = list(
    object(
      {
        name    = string
        type    = string
        rrdatas = optional(list(string), [])
        ttl     = number
      }
    )
  )
  default = []
}
