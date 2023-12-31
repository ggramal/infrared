variable "name" {
  description = "Custom role name"
  type        = string
}

variable "title" {
  description = "Custom role title"
  type        = string
}

variable "description" {
  description = "Custom role description"
  type        = string
}

variable "permissions" {
  description = "Custom role permissions"
  type        = list(string)
}
