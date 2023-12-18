output "vpc" {
  value = module.vpc
}

output "subnets" {
  value = module.subnets.subnets
}


output "nats" {
  value = {
    for nat_name, nat_obj in var.nat_gws :
    nat_name => merge(
      module.cloud_nats[nat_name],
      {
        "ips" = [
          for ip_name in nat_obj.ip_address_names :
          google_compute_address.ip_addresses[ip_name].address
        ]
      }
    )
  }
}
