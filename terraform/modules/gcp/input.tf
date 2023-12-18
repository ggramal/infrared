variable "project" {
  description = "Project configuration"
  type = object({
    id     = string
    region = string
  })
}

variable "gcs" {
  description = "A list of gcs buckets more info - https://github.com/terraform-google-modules/terraform-google-cloud-storage"
  type        = any
  default     = {}
}

variable "activate_apis" {
  description = "What apis need to be activated in a gcp project"
  type        = list(string)
}

variable "gke_clusters" {
  description = "A list of gke clusters more info - https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/private-cluster"
  type        = map(any)
  default     = {}
}

variable "networks" {
  description = "Networking configuration for this project"
  type        = map(any)
  default     = {}
}

variable "iam" {
  description = "Gcp project iam definition more info in submodule  ./iam"
  type = object(
    {
      custom_roles     = any
      service_accounts = any
      roles            = any
    }
  )
  default = {
    custom_roles     = {}
    service_accounts = {}
    roles            = {}
  }
}

variable "gcrs" {
  description = "A list of gcr registries to create in this project"
  type        = map(any)
  default     = {}
}

variable "dns_zones" {
  description = "A list of dns zones to create in this project"
  type        = map(any)
  default     = {}
}

variable "cloudsql_postgres" {
  description = "A list of cloudsql postgres dbs more info"
  type        = map(any)
  default     = {}
}

variable "redis_instances" {
  description = "A list of memorystore redis instances"
  type        = map(any)
  default     = {}
}
