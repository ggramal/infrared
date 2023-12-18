locals {
  cluster = {
    project_id              = var.cluster.project_id
    name                    = var.cluster.name
    cluster_type            = var.cluster.cluster_type
    provider_backup_enabled = try(var.cluster.provider_backup_enabled, null)
    backup_enabled          = try(var.cluster.backup_enabled, null)
    mongo_db_major_version  = var.cluster.mongo_db_major_version
    disk_size_gb            = var.cluster.disk_size_gb

    provider = {
      name               = var.cluster.provider.name
      region_name        = var.cluster.provider.region_name
      instance_size_name = var.cluster.provider.instance_size_name
    }

    replication_specs = [
      for spec in var.cluster.replication_specs :
      {
        num_shards = spec.num_shards
        zone_name  = spec.zone_name
        regions_config = [
          for region in spec.regions_config :
          {
            analytics_nodes = region.analytics_nodes
            electable_nodes = region.electable_nodes
            priority        = region.priority
            read_only_nodes = region.read_only_nodes
            region_name     = region.region_name
          }
        ]
      }
    ]
  }
}

variable "cluster" {
  type = any
}
