locals {
  subnets = [
    for subnet_name, subnet_obj in var.subnets :
    {
      subnet_name   = subnet_name
      subnet_ip     = subnet_obj.ip_cidr_range
      subnet_region = subnet_obj.region
      description   = subnet_obj.description
    }
  ]
  secondary_ranges = merge(
    [
      for subnet_name, subnet_obj in var.subnets :
      {
        "${subnet_name}" = subnet_obj.secondary_ip_range
      }
      if subnet_obj.secondary_ip_range != []
    ]...
  )
}


variable "vpc" {
  description = "Vpc description"
  type = object(
    {
      name       = string
      project_id = string
    }
  )
}

variable "subnets" {
  description = "subnets that should be created"
  type = map(
    object(
      {
        ip_cidr_range = string
        region        = string
        description   = optional(string, null)
        secondary_ip_range = optional(
          list(
            object(
              {
                range_name    = string
                ip_cidr_range = string
              }
            )
          ),
          []
        )
        cloudrun_connector = optional(
          object(
            {
              machine_type  = string
              min_instances = optional(number, 2)
              max_instances = optional(number, 3)
            }
          )
          ,
        )
      }
    )
  )
}

variable "nat_gws" {
  description = "Map of nat gws to create"
  type = map(
    object(
      {
        router_name = string
        region      = string
        ip_address_names = optional(
          list(string),
          []
        )
        log_config_enable = optional(string, true)
        log_config_filter = optional(string, "ERRORS_ONLY")
      }
    )
  )
}

variable "routers" {
  description = "Map of routers to create"
  type = map(
    object(
      {
        region = string
      }
    )
  )
}

variable "ip_addresses" {
  description = "List of ip addresses to create"
  type = list(
    object(
      {
        name        = string
        description = string
      }
    )
  )
  default = []
}


variable "firewall_rules" {
  description = "List of firewall rules"
  type        = map(any)
  default     = {}
}
