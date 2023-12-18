variable "project_id" {
  type = string
}

variable "pullers" {
  type    = list(any)
  default = []
}

variable "pushers" {
  type    = list(any)
  default = []
}

variable "registry" {
  type = object(
    {
      location          = string
      create            = optional(bool, true)
      gcr_bucket_prefix = optional(string, "")
    }
  )
}
