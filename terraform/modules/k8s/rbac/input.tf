variable "custom_service_accounts" {
  type = map(object
    (
      {
        secret                          = optional(map(string), {})
        automount_service_account_token = optional(bool, true)
        annotations                     = optional(map(string))
        namespace                       = string
        name                            = string
      }
    )
  )
  default = {}
}
variable "custom_cluster_roles" {
  type    = map(any)
  default = {}
}
variable "custom_cluster_role_binding" {
  type    = map(any)
  default = {}
}
variable "custom_roles" {
  type = map(any)
}
variable "custom_role_binding" {
  type = map(any)
}
