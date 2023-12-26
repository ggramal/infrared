variable "name" {
  description = "Firestore db name"
  type        = string
}

variable "location_id" {
  description = "Firestore db location"
  type        = string
}

variable "type" {
  description = "Firestore db type"
  type        = string
}

variable "concurrency_mode" {
  description = "Firestore db confcurrency mode"
  type        = string
  default     = null
}

variable "app_engine" {
  description = "Firestore db app engine integration mode to use"
  type = object(
    {
      integration_mode = string
      create           = bool
    }
  )
  default = {
    integration_mode = "DISABLED"
    create           = false
  }
}

variable "delete_protection_state" {
  description = "Firestore db delete protection state"
  type        = string
  default     = "DELETE_PROTECTION_DISABLED"
}

variable "deletion_policy" {
  description = "Firestore db deletion behaviour"
  type        = string
  default     = "ABANDON"
}
