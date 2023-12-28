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

output "redis" {
  value = module.redis
}

output "cloudrun_services" {
  value = {
    for cloudrun_service_name, cloudrun_service_obj in module.cloudrun_services :
    cloudrun_service_name => cloudrun_service_obj.cloudrun_service
  }
}

output "application_lbs" {
  value = {
    for application_lb_name, application_lb_obj in module.application_lbs :
    application_lb_name => application_lb_obj.application_lb
  }
}

output "kms" {
  value = {
    for kms_name, kms_obj in module.kms :
    kms_name => kms_obj
  }
}

output "tasks" {
  value = {
    for task_name, task_obj in module.cloud_tasks :
    task_name => task_obj.task
  }
}
