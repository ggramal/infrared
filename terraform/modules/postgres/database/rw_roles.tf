locals {
  /* Many to many (roles, ["table", "sequence"],schemas) */

  dbs_rw_roles = flatten([
    for rk, rv in var.rw_roles : [
      for obj in ["table", "sequence"] : [
        for s in postgresql_schema.schemas : {
          db     = postgresql_database.db.name
          role   = rk
          schema = s.name
          object = obj
        }
      ]
    ]
  ])

  /* Many to many (owners,roles, ["table", "sequence"],schemas) */

  dbs_rw_roles_owner = flatten([
    for rk, rv in var.rw_roles : [
      for obj in ["table", "sequence"] : [
        for own in local.potential_owners : [
          for s in postgresql_schema.schemas : {
            db     = postgresql_database.db.name
            role   = rk
            schema = s.name
            object = obj
            owner  = own
          }
        ]
      ]
    ]
  ])
}

resource "postgresql_grant" "rw_roles" {
  for_each = {
    for g in local.dbs_rw_roles : "${g.db}.${g.schema}.${g.role}.${g.object}" => g
  }
  database    = each.value.db
  role        = each.value.role
  schema      = each.value.schema
  object_type = each.value.object
  privileges  = each.value.object == "sequence" ? ["SELECT", "USAGE", "UPDATE"] : ["SELECT", "INSERT", "UPDATE", "DELETE"]
  depends_on = [
    postgresql_grant.owner_roles
  ]
}

resource "postgresql_default_privileges" "rw_roles" {
  for_each = {
    for g in local.dbs_rw_roles_owner : "${g.db}.${g.schema}.${g.role}.${g.object}.${g.owner}" => g
  }
  database    = each.value.db
  role        = each.value.role
  schema      = each.value.schema
  object_type = each.value.object
  owner       = each.value.owner
  privileges  = each.value.object == "sequence" ? ["SELECT", "USAGE", "UPDATE"] : ["SELECT", "INSERT", "UPDATE", "DELETE"]
  depends_on = [
    postgresql_default_privileges.owner_roles
  ]
}
