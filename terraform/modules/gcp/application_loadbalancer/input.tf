variable "name" {
  description = "Application loadbalancer name"
  type        = string
}

variable "backends" {
  description = "Application loadbalancer backends"
  type = map(
    object(
      {
        port_name             = string
        protocol              = string
        timeout_sec           = optional(number, 30)
        load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")
        backend = object(
          {
            group = string
          }
        )
      }
    )
  )
}

variable "https_target" {
  description = "Https target of application loadbalancer"
  type = object(
    {
      port_range            = optional(string, "443")
      cert_domains          = list(string)
      load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")
      default_url_redirect = optional(
        object(
          {
            https_redirect         = optional(bool, false)
            redirect_response_code = string
            strip_query            = optional(bool, false)
            path_redirect          = optional(string)
            host_redirect          = optional(string)
          }
        )
      )
      default_backend_name = optional(string)
      rules = map(
        object(
          {
            hosts                = list(string)
            default_backend_name = optional(string)
            route_rules = optional(
              list(
                object(
                  {
                    priority     = number
                    backend_name = string
                    header_action = optional(
                      object(
                        {
                          response_headers_to_add = optional(map(string))
                        }
                      )
                    )
                    match_rules = list(
                      object(
                        {
                          prefix_match = optional(string)
                          regex_match  = optional(string)
                        }
                      )
                    )
                  }
                )
              )
            )
            path_rules = optional(
              list(
                object(
                  {
                    paths        = list(string)
                    backend_name = string
                    route_action = optional(
                      object(
                        {
                          cors = optional(
                            object(
                              {
                                allow_credentials = optional(bool, false)
                                allow_headers     = optional(list(string))
                                allow_origins     = list(string)
                                max_age           = number
                                allow_methods     = list(string)
                                disabled          = optional(bool, false)
                              }
                            )
                          )
                        }
                      ),
                    )
                  }
                )
              )
            )
          }
        )
      )
    }
  )
}

variable "http_target" {
  description = "Http target of application loadbalancer"
  type = object(
    {
      port_range            = optional(string, "80")
      load_balancing_scheme = optional(string, "EXTERNAL_MANAGED")
      default_url_redirect = optional(
        object(
          {
            https_redirect         = optional(bool, false)
            redirect_response_code = string
            strip_query            = optional(bool, false)
            path_redirect          = optional(string)
            host_redirect          = optional(string)
          }
        )
      )
      default_backend_name = optional(string)
      rules = map(
        object(
          {
            hosts                = list(string)
            default_backend_name = optional(string)
            path_rules = optional(
              list(
                object(
                  {
                    paths        = list(string)
                    backend_name = string
                    route_action = optional(
                      object(
                        {
                          cors = optional(
                            object(
                              {
                                allow_credentials = optional(bool, false)
                                allow_headers     = optional(list(string))
                                allow_origins     = list(string)
                                max_age           = number
                                allow_methods     = list(string)
                                disabled          = optional(bool, false)
                              }
                            )
                          )
                        }
                      ),
                    )
                  }
                )
              )
            )
          }
        )
      )
    }
  )
}
