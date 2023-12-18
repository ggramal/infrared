resource "postgresql_role" "app_users" {
  for_each            = var.app_users
  login               = true
  skip_reassign_owned = true
  password            = each.value.password == null ? random_password.passwords[each.key].result : each.value.password
  name                = each.key
  depends_on = [
    postgresql_role.rw_roles,
    postgresql_role.ro_roles,
    postgresql_role.owner_roles
  ]

  lifecycle {
    ignore_changes = [
      roles,
    ]
  }
}

resource "postgresql_role" "system_users" {
  for_each            = var.system_users
  create_role         = true
  create_database     = each.value.create_database
  login               = true
  skip_drop_role      = true
  skip_reassign_owned = true
  password            = each.value.password == null ? random_password.passwords[each.key].result : each.value.password
  name                = each.key
  depends_on = [
    postgresql_role.app_users
  ]
  lifecycle {
    ignore_changes = [
      roles,
    ]
  }
}

resource "postgresql_grant_role" "all_roles" {
  for_each = toset(
    flatten(
      [
        for user, user_obj in local.all_roles :
        [
          for role, role_obj in local.all_roles :
          format("%s@%s", user, role)
          if contains(role_obj.grant_to, user)
        ]
      ]
    )
  )

  role       = regex("(?P<user>.*)@(?P<role>.*)", each.value)["user"]
  grant_role = regex("(?P<user>.*)@(?P<role>.*)", each.value)["role"]
  #with_admin_option = true
  depends_on = [
    postgresql_role.system_users,
    postgresql_role.app_users,
    postgresql_role.ro_roles,
    postgresql_role.rw_roles,
    postgresql_role.owner_roles
  ]
}


resource "postgresql_role" "rw_roles" {
  for_each            = var.rw_roles
  name                = each.key
  skip_drop_role      = each.value.skip_drop_role
  skip_reassign_owned = each.value.skip_reassign_owned
  lifecycle {
    ignore_changes = [
      roles,
    ]
  }
}

resource "postgresql_role" "ro_roles" {
  for_each            = var.ro_roles
  name                = each.key
  skip_drop_role      = each.value.skip_drop_role
  skip_reassign_owned = each.value.skip_reassign_owned
  lifecycle {
    ignore_changes = [
      roles,
    ]
  }
}

resource "postgresql_role" "owner_roles" {
  for_each            = var.owner_roles
  name                = each.key
  skip_drop_role      = each.value.skip_drop_role
  skip_reassign_owned = each.value.skip_reassign_owned
  lifecycle {
    ignore_changes = [
      roles,
    ]
  }
}

resource "random_password" "passwords" {
  for_each = toset(
    [
      for user, user_obj in merge(
        var.system_users,
        var.app_users
      ) :
      user
      if user_obj.password == null
    ]
  )
  length  = 32
  special = false
}
