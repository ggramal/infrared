locals {
  networks = {
    main = {
      authorized_networks = {
        allow-all = {
          cidr_block   = "0.0.0.0/0"
          display_name = "Allow all"
        }
      }
      vpc = {
        name = "main"
      }
      subnets = {
        "vms" = {
          ip_cidr_range = "10.8.0.0/20"
          region        = var.gcp_projects.int.region
          description   = "VM subnet"
          secondary_ip_range = [
            {
              range_name    = "pods"
              ip_cidr_range = "10.12.0.0/14"
            },
            {
              range_name    = "services"
              ip_cidr_range = "10.9.0.0/20"
            }
          ]
        }
      }
      nat_gws = {
        "nat-gw" = {
          region      = var.gcp_projects.int.region
          router_name = "router"
          ip_address_names = [
            "nat-gw-ip-1"
          ]
        }
      }
      routers = {
        "router" = {
          region = var.gcp_projects.int.region
        }
      }
      ip_addresses = [
        {
          name        = "nat-gw-ip-1"
          description = "ip address for nat gw ${var.gcp_projects.int.region}"
        }
      ]
      firewall_rules = {
        admission-webhooks = {
          direction = "INGRESS"
          source_ranges = [
            "172.16.0.0/28"
          ]
          target_tags = []
          description = null
          allow = {
            "tcp" = {
              ports = [
                "8080", #konghq
              ]
            }
          }
          deny = {}
        }
      }
    }
  }
}
