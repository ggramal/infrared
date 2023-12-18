resource "google_redis_instance" "redis-instance" {
  name               = var.name
  memory_size_gb     = var.memory_size_gb
  redis_configs      = var.redis_configs
  redis_version      = var.redis_version
  tier               = var.tier
  auth_enabled       = var.auth_enabled
  authorized_network = var.auth_network
  labels = {
    resource_type = "redis_instance",
    instance_name = var.name,
  }
}
