variable "name" {
  description = "Cloudrun service name"
  type        = string
}

variable "location" {
  description = "Cloudrun service location"
  type        = string
}

variable "execution_environment" {
  description = "Cloudrun execution environment EXECUTION_ENVIRONMENT_GEN2|EXECUTION_ENVIRONMENT_GEN1"
  type        = string
  default     = "EXECUTION_ENVIRONMENT_GEN2"
}

variable "ingress" {
  description = "cloudrun service ingress policy"
  type        = string
}

variable "service_account" {
  description = "cloudrun service google service account"
  type        = string
}

variable "neg_enabled" {
  description = "enable neg for cloudrun service"
  type        = bool
  default     = false
}

variable "volumes" {
  description = "volumes definition"
  type = map(
    object(
      {
        name = string
        secret = object(
          {
            secret = string
            items = object(
              {
                version = string
                path    = string
              }
            )
          }
        )
      }
    )
  )

  default = {}
}

variable "container" {
  description = "Cloudrun container definition"
  type = object(
    {
      image = string
      volume_mounts = optional(
        map(
          object(
            {
              name = string
              path = string
            }
          )
        )
      )
      ports = list(
        object(
          {
            name           = optional(string)
            container_port = number
          }
        )
      )
      env = optional(
        list(
          object(
            {
              name  = string
              value = optional(string)
              secret_key_ref = optional(
                object(
                  {
                    secret  = string
                    version = string
                  }
                )
              )
            }
          )
        ),
        []
      )
      resources = object(
        {
          limits = object(
            {
              memory = string
              cpu    = string
            }
          )
          cpu_idle          = optional(bool, true)
          startup_cpu_boost = optional(bool, false)
        }
      )
    }
  )
}

variable "scaling" {
  description = "cloudrun service scaling options"
  type = object(
    {
      min_instance_count = number
      max_instance_count = number
    }
  )
}

variable "vpc_access" {
  description = "cloudrun service vpc access configuration"
  type = object(
    {
      connector = string
      egress    = string
    }
  )
  default = null
}

variable "members" {
  type        = list(string)
  description = "Users/SAs to be given invoker access to the service"
  default     = []
}
