module "db" {
  source                  = "./db"
  name                    = var.db.name
  location_id             = var.db.location_id
  type                    = var.db.type
  concurrency_mode        = var.db.concurrency_mode
  app_engine              = var.db.app_engine
  delete_protection_state = var.db.delete_protection_state
  deletion_policy         = var.db.deletion_policy
}

module "datastore_indices" {
  source     = "./datastore_index"
  for_each   = var.datastore_indices
  kind       = each.value.kind
  properties = each.value.properties
}
