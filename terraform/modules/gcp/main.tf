module "enable_apis" {
  source = "git::ssh://git@github.com/terraform-google-modules/terraform-google-project-factory//modules/project_services?ref=v14.4.0"

  project_id = var.project.id

  activate_apis = var.activate_apis
}


/* network */

module "network" {
  for_each = var.networks
  source   = "./network"

  vpc = {
    name       = each.value.vpc.name
    project_id = module.enable_apis.project_id
  }
  subnets        = each.value.subnets
  routers        = each.value.routers
  ip_addresses   = each.value.ip_addresses
  nat_gws        = each.value.nat_gws
  firewall_rules = each.value.firewall_rules
}


module "gke" {
  source                          = "git::ssh://git@github.com/terraform-google-modules/terraform-google-kubernetes-engine.git//modules/private-cluster?ref=v29.0.0"
  for_each                        = var.gke_clusters
  project_id                      = var.project.id
  kubernetes_version              = each.value.kubernetes_version
  name                            = each.value.name
  regional                        = each.value.regional
  region                          = each.value.region
  zones                           = each.value.zones
  network                         = each.value.network
  subnetwork                      = each.value.subnetwork
  ip_range_pods                   = each.value.ip_range_pods
  ip_range_services               = each.value.ip_range_services
  http_load_balancing             = each.value.http_load_balancing
  horizontal_pod_autoscaling      = each.value.horizontal_pod_autoscaling
  create_service_account          = each.value.create_service_account
  node_metadata                   = each.value.node_metadata
  enable_vertical_pod_autoscaling = each.value.enable_vertical_pod_autoscaling
  enable_shielded_nodes           = each.value.enable_shielded_nodes
  network_policy                  = each.value.network_policy
  network_policy_provider         = each.value.network_policy_provider

  identity_namespace = each.value.identity_namespace
  cluster_resource_labels = merge(
    each.value.cluster_resource_labels,
    {
      resource_type = "gke_cluster",
      cluster_name  = each.value.name,
    },
  )
  remove_default_node_pool     = each.value.remove_default_node_pool
  authenticator_security_group = each.value.authenticator_security_group

  master_authorized_networks         = each.value.master_authorized_networks
  master_global_access_enabled       = each.value.master_global_access_enabled
  resource_usage_export_dataset_id   = each.value.resource_usage_export_dataset_id
  enable_network_egress_export       = each.value.enable_network_egress_export
  enable_resource_consumption_export = each.value.enable_resource_consumption_export
  enable_private_nodes               = each.value.enable_private_nodes
  enable_private_endpoint            = each.value.enable_private_endpoint
  master_ipv4_cidr_block             = each.value.master_ipv4_cidr_block

  maintenance_start_time = each.value.maintenance_start_time
  maintenance_recurrence = each.value.maintenance_recurrence
  maintenance_end_time   = each.value.maintenance_end_time

  monitoring_enable_managed_prometheus = try(each.value.monitoring.managed_prometheus.enabled, false)
  monitoring_enabled_components        = try(each.value.monitoring.components, ["SYSTEM_COMPONENTS"])
  node_pools                           = each.value.node_pools
  node_pools_oauth_scopes              = each.value.node_pools_oauth_scopes
  node_pools_labels                    = each.value.node_pools_labels
  node_pools_metadata                  = each.value.node_pools_metadata
  node_pools_taints                    = each.value.node_pools_taints
  node_pools_tags                      = each.value.node_pools_tags

  depends_on = [
    module.enable_apis,
    module.network,
    module.iam,
  ]
}

/* cloudsql */

module "cloudsql_postgres" {
  source              = "git::ssh://git@github.com/terraform-google-modules/terraform-google-sql-db.git//modules/postgresql?ref=master"
  for_each            = var.cloudsql_postgres
  project_id          = var.project.id
  name                = each.key
  database_version    = each.value.postgresql_version
  zone                = each.value.zone
  disk_size           = each.value.settings.disk_size
  disk_type           = each.value.settings.disk_type
  tier                = each.value.settings.tier
  region              = each.value.region
  availability_type   = each.value.settings.availability_type
  deletion_protection = each.value.deletion_protection
  iam_users           = each.value.iam_users
  user_password       = random_password.cloudsql_passwords[each.key].result
  user_name           = each.value.user.name
  user_labels = merge(
    each.value.user_labels,
    {
      resource_type = "cloudsql_database",
      database_name = each.key,
    },
  )

  insights_config = try(each.value.insights_config, null)

  maintenance_window_day          = each.value.maintenance.window_day
  maintenance_window_hour         = each.value.maintenance.window_hour
  maintenance_window_update_track = each.value.maintenance.window_update_track

  backup_configuration = each.value.backup_configuration

  database_flags = each.value.database_flags

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = each.value.network.network_id
    require_ssl         = false
    authorized_networks = each.value.network.authorized_networks
    allocated_ip_range  = each.value.network.allocated_ip_range
  }
  depends_on = [
    module.enable_apis,
    module.network
  ]
}

/* Secrets */

resource "random_password" "cloudsql_passwords" {
  for_each = var.cloudsql_postgres
  length   = 32
  special  = false
}

/* GCS */

module "gcs" {
  source     = "git::ssh://git@github.com/terraform-google-modules/terraform-google-cloud-storage.git?ref=v5.0.0"
  for_each   = var.gcs
  names      = [each.key]
  project_id = var.project.id
  location   = each.value.location
  bucket_policy_only = {
    tostring(each.key) = each.value.bucket_policy_only
  }
  prefix            = each.value.prefix
  storage_class     = each.value.storage_class
  set_admin_roles   = true
  set_creator_roles = true
  set_viewer_roles  = true
  admins            = each.value.admins
  viewers           = each.value.viewers
  creators          = each.value.creators
  versioning = {
    tostring(each.key) = each.value.versioning
  }
  lifecycle_rules = each.value.lifecycle_rules
  cors            = each.value.cors
  labels = {
    resource_type = "gcs_bucket",
    bucket_name   = each.key,
  }
  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

/* gcr */

module "gcrs" {
  source     = "./gcr"
  for_each   = var.gcrs
  project_id = var.project.id
  registry   = each.value.registry
  pullers    = each.value.pullers
  pushers    = each.value.pushers
  depends_on = [
    module.enable_apis,
  ]
}

/* IAM */

module "iam" {
  source           = "./iam"
  custom_roles     = var.iam.custom_roles
  service_accounts = var.iam.service_accounts
  roles            = var.iam.roles
  project_id       = var.project.id
  depends_on = [
    module.enable_apis,
  ]
}

/* dns */

module "dns" {
  source   = "./dns"
  for_each = var.dns_zones
  zone     = each.value.zone
  records  = each.value.records
  depends_on = [
    module.enable_apis,
  ]
}


/* Memorystore */

module "redis" {
  source         = "./memorystore_redis"
  for_each       = var.redis_instances
  name           = each.value.name
  memory_size_gb = each.value.memory_size_gb
  redis_configs  = each.value.redis_configs
  redis_version  = each.value.redis_version
  tier           = each.value.tier
  auth_enabled   = try(each.value.auth_enabled, "false")
  auth_network   = each.value.auth_network

  depends_on = [
    module.enable_apis,
  ]
}

/* cloudrun */

module "cloudrun_services" {
  source   = "./cloudrun_service"
  for_each = var.cloudrun_services
  name     = each.value.name
  location = each.value.location
  execution_environment = try(
    each.value.execution_environment,
    "EXECUTION_ENVIRONMENT_GEN2"
  )

  ingress         = each.value.ingress
  members         = try(each.value.members, [])
  neg_enabled     = try(each.value.neg_enabled, false)
  container       = each.value.container
  scaling         = each.value.scaling
  service_account = each.value.service_account
  vpc_access      = try(each.value.vpc_access, null)
  volumes         = try(each.value.volumes, {})

  depends_on = [
    module.enable_apis,
    module.iam,
  ]
}

/* albs */

module "application_lbs" {
  source       = "./application_loadbalancer"
  for_each     = var.application_lbs
  name         = each.value.name
  backends     = each.value.backends
  http_target  = each.value.http_target
  https_target = each.value.https_target
}

/* kms */

module "kms" {
  source   = "./kms"
  for_each = var.kms_key_rings
  key_ring = {
    name     = each.value.name
    location = try(each.value.location, var.project.region)
  }
  keys = each.value.keys

  depends_on = [
    module.iam,
  ]
}

/* cloud tasks */

module "cloud_tasks" {
  source = "./cloud_task"
  for_each = var.cloud_tasks
  name = each.value.name
  location = each.value.location
  rate_limits = each.value.rate_limits
  retry_configs = each.value.retry_configs
}
