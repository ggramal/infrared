variable "labels" {
  description = "Labels of the secret"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations of the secrets"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "is_base64" {
  description = "Is secret base64 encoded"
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "Iam roles for the secret"
  type = list(
    object(
      {
        role    = string
        members = list(string)
      }
    )
  )
}

variable "secret" {
  description = "Secret data"
  type        = string
}

variable "kms_key" {
  description = "Kms key name"
  type        = string
  default     = null
}
