variable "memory_size_gb" {
  type        = number
  description = "Size of ram provisioned to redis instance"
}

variable "redis_configs" {
  type        = map(string)
  description = "Redis related configs"
}

variable "redis_version" {
  type        = string
  description = "Redis version"
}

variable "tier" {
  type        = string
  description = "BASIC or STANDARD_HA tier"
}

variable "name" {
  type        = string
  description = "Redis instance name"
}

variable "auth_enabled" {
  type        = bool
  description = "Enable auth for Redis instance"
  default     = false
}

variable "auth_network" {
  type        = string
  description = "Name of authorized network for Redis instance"
  default     = "default"
}
