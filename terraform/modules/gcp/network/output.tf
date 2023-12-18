output "vpc" {
  value = module.vpc
}

output "subnets" {
  value = {
    for subnet_name, subnet_obj in var.subnets :
    subnet_name => merge(
      module.subnets.subnets["${subnet_obj.region}/${subnet_name}"]
      ,
      {
        cloudrun_connector = lookup(
          subnet_obj,
          "cloudrun_connector",
          null
        ) != null ? google_vpc_access_connector.cloudrun_connector[subnet_name] : null
      }

    )

  }
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
