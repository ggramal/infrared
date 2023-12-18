output "vpcs" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.vpc
  }
}

output "subnets" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.subnets
  }
}

output "nats" {
  value = {
    for network_name, network_obj in module.network :
    network_name => network_obj.nats
  }
}

output "service_accounts" {
  value = module.iam.service_accounts
}

output "cloudsql_postgres" {
  value = {
    for pg_name, pg_obj in module.cloudsql_postgres :
    pg_name => merge(
      pg_obj,
      {
        superuser_password = random_password.cloudsql_passwords[pg_name].result
        superuser_name     = var.cloudsql_postgres[pg_name].user.name
      }
    )
  }
}
