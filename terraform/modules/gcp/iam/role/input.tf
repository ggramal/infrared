variable "project_id" {
  description = "gcp project id"
  type        = string
}

variable "role" {
  description = "Iam role"
  type        = string
}

variable "members" {
  description = "Members of specified role"
  type        = list(string)
}
