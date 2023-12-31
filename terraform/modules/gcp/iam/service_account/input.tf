variable "project_id" {
  description = "gcp project id"
  type        = string
}

variable "name" {
  description = "Service account name"
  type        = string
}

variable "description" {
  description = "Service account description"
  type        = string
}

variable "roles" {
  description = "Service account roles"
  type        = list(string)
  default     = []
}

#service accounts can be treated
#as gcp resources. So you can
#grant service accounts to specific
#iam entities
variable "sa_iam_bindings" {
  description = "Service account iam bindings"
  type = map(
    list(string)
  )
  default = {}
}

variable "generate_key" {
  description = "Generate key or not for this service account"
  type        = bool
  default     = "false"
}
