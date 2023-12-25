module "db" {
  source                      = "./db"
  name                        = var.db.name
  location_id                 = var.db.location_id
  type                        = var.db.type
  concurrency_mode            = var.db.concurrency_mode
  app_engine_integration_mode = var.db.app_engine_integration_mode
  delete_protection_state     = var.db.delete_protection_state
  deletion_policy             = var.db.deletion_policy
}
