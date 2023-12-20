variable "name" {
  description = "Cloud scheduler name"
  type        = string
}

variable "schedule" {
  description = "Cloud scheduler schedule"
  type        = string
}

variable "location" {
  description = "Cloud scheduler location"
  type        = string
  default     = null
}

variable "description" {
  description = "Cloud scheduler description"
  type        = string
  default     = ""
}

variable "timezone" {
  description = "Cloud scheduler timezone"
  type        = string
  default     = "Etc/UTC"
}

variable "paused" {
  description = "If the cloud scheduler job is paused or not"
  type        = bool
  default     = false
}

variable "attempt_deadline" {
  description = "The deadline for job attempts."
  type        = string
  default     = null
}

variable "retry_configs" {
  description = "Cloud scheduler retry configuration"
  type = object(
    {
      retry_count          = optional(number)
      max_retry_duration   = optional(string)
      min_backoff_duration = optional(string)
      max_backoff_duration = optional(string)
      max_doublings        = optional(number)
    }
  )

  default = null
}

variable "http_target" {
  description = "scheduler http target"
  type = object(
    {
      uri         = string
      http_method = string
      body        = optional(string)
      headers     = optional(map(string))
    }
  )
  default = null
}
