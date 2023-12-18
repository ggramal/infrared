resource "mongodbatlas_cluster" "this" {
  project_id              = local.cluster.project_id
  name                    = local.cluster.name
  cluster_type            = local.cluster.cluster_type
  provider_backup_enabled = local.cluster.provider_backup_enabled
  backup_enabled          = local.cluster.backup_enabled
  mongo_db_major_version  = local.cluster.mongo_db_major_version

  provider_name               = local.cluster.provider.name
  provider_region_name        = local.cluster.provider.region_name
  provider_instance_size_name = local.cluster.provider.instance_size_name
  disk_size_gb                = local.cluster.disk_size_gb

  dynamic "replication_specs" {
    for_each = local.cluster.replication_specs
    content {
      num_shards = replication_specs.value.num_shards
      zone_name  = replication_specs.value.zone_name
      dynamic "regions_config" {
        for_each = replication_specs.value.regions_config
        content {
          analytics_nodes = regions_config.value.analytics_nodes
          electable_nodes = regions_config.value.electable_nodes
          priority        = regions_config.value.priority
          read_only_nodes = regions_config.value.read_only_nodes
          region_name     = regions_config.value.region_name
        }
      }
    }
  }
}
