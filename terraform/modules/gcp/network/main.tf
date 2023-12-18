module "vpc" {
  source       = "git::ssh://git@github.com/terraform-google-modules/terraform-google-network//modules/vpc?ref=v8.0.0"
  project_id   = var.vpc.project_id
  network_name = var.vpc.name
}

module "subnets" {
  source           = "git::ssh://git@github.com/terraform-google-modules/terraform-google-network//modules/subnets?ref=v8.0.0"
  project_id       = module.vpc.project_id
  network_name     = module.vpc.network_name
  subnets          = local.subnets
  secondary_ranges = local.secondary_ranges
}

resource "google_vpc_access_connector" "cloudrun_connector" {
  for_each = {
    for subnet_name, subnet_obj in var.subnets :
    subnet_name => subnet_obj
    if subnet_obj.cloudrun_connector != null
  }
  name = each.key
  subnet {
    name = module.subnets.subnets["${each.value.region}/${each.key}"].name
  }
  machine_type  = each.value.cloudrun_connector.machine_type
  min_instances = each.value.cloudrun_connector.min_instances
  max_instances = each.value.cloudrun_connector.max_instances
  region        = each.value.region
  project       = var.vpc.project_id
}

module "cloud_routers" {
  source     = "git::ssh://git@github.com/terraform-google-modules/terraform-google-cloud-router.git?ref=v6.0.2"
  for_each   = var.routers
  name       = each.key
  project    = module.vpc.project_id
  region     = each.value.region
  network    = module.vpc.network_self_link
  depends_on = [module.subnets]
}

resource "google_compute_address" "ip_addresses" {
  for_each = {
    for ip_address in var.ip_addresses :
    "${ip_address.name}" => ip_address
  }
  name        = each.key
  description = each.value.description
}

module "cloud_nats" {
  source     = "git::ssh://git@github.com/terraform-google-modules/terraform-google-cloud-nat.git?ref=v5.0.0"
  for_each   = var.nat_gws
  router     = each.value.router_name
  project_id = module.vpc.project_id
  region     = each.value.region
  name       = each.key
  nat_ips = [
    for ip_address in each.value.ip_address_names :
    google_compute_address.ip_addresses[ip_address].self_link
  ]
  log_config_enable = each.value.log_config_enable
  log_config_filter = each.value.log_config_filter
  depends_on        = [module.cloud_routers]
}

module "google_services_peering" {
  source = "./google-services-peering"
  vpc = {
    project_id = module.vpc.project_id
    self_link  = module.vpc.network_self_link
    name       = module.vpc.network_name
  }
  peering_net = {
    prefix_length = 16
  }
}


module "firewall_rules" {
  source  = "./firewall-rules"
  network = module.vpc.network_name
  rules   = var.firewall_rules
}
