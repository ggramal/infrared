variable "data" {
  description = "k8s secret data"
  type        = map(string)
}

variable "name" {
  description = "k8s secret name"
  type        = string
}

variable "annotations" {
  description = "k8s secret annotations"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "k8s secret labels"
  type        = map(string)
  default     = {}
}

variable "namespace" {
  description = "k8s secret namespace"
  type        = string
}
