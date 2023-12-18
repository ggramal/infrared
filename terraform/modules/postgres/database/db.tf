resource "postgresql_database" "db" {
  name              = var.database.name
  owner             = var.database.owner
  template          = var.database.template
  lc_collate        = var.database.collate
  lc_ctype          = var.database.ctype
  connection_limit  = var.database.connection_limit
  allow_connections = var.database.allow_connections
}



resource "postgresql_extension" "extention" {
  for_each = toset(var.extensions)
  name     = each.key
  database = postgresql_database.db.name
}

resource "postgresql_schema" "schemas" {
  for_each     = var.schemas
  name         = each.key
  owner        = each.value.owner
  database     = postgresql_database.db.name
  drop_cascade = true
}

resource "postgresql_grant" "schema_owners" {
  for_each = toset(
    flatten(
      [
        for schema_name, schema_obj in postgresql_schema.schemas :
        [
          for role_name, role_obj in var.owner_roles :
          format("%s@%s", role_name, schema_name)
        ]
      ]
    )
  )
  database    = var.database.name
  role        = regex("(?P<role>.*)@(?P<schema>.*)", each.value)["role"]
  schema      = regex("(?P<role>.*)@(?P<schema>.*)", each.value)["schema"]
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
}

resource "postgresql_grant" "schema_rw_ro" {
  for_each = toset(
    flatten(
      [
        for schema_name, schema_obj in postgresql_schema.schemas :
        [
          for role_name, role_obj in merge(var.rw_roles, var.ro_roles) :
          format("%s@%s", role_name, schema_name)
        ]
      ]
    )
  )
  database    = var.database.name
  role        = regex("(?P<role>.*)@(?P<schema>.*)", each.value)["role"]
  schema      = regex("(?P<role>.*)@(?P<schema>.*)", each.value)["schema"]
  object_type = "schema"
  privileges  = ["USAGE"]
  depends_on = [
    postgresql_grant.schema_owners
  ]
}

resource "postgresql_grant" "revoke_public" {
  database    = var.database.name
  role        = "public"
  schema      = "public"
  object_type = "schema"
  privileges  = []
  depends_on = [
    postgresql_grant.schema_rw_ro
  ]
}
