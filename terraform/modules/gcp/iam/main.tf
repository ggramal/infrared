locals {
  sa_role_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for role in sa.roles : {
        sa_key = sa_key
        role   = role
        email  = google_service_account.service-accounts[sa_key].email
      }
    ]
  ])

  sa_custom_role_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for custom_role in sa.custom_roles : {
        sa_key = sa_key
        role   = custom_role
        email  = google_service_account.service-accounts[sa_key].email
      }
    ]
  ])

  sa_iam_bindings = flatten([
    for sa_key, sa in var.service_accounts : [
      for role, members in sa.sa_iam_bindings : {
        sa_key  = sa_key
        members = members
        role    = role
        email   = google_service_account.service-accounts[sa_key].email
      }
    ]
  ])

  role_bindings = flatten([
    for role, value in var.roles : [
      for member in value.members : {
        role   = value.role
        member = member
      }
    ]
  ])

  custom_role_bindings = flatten([
    for role, value in var.custom_roles : [
      for member in value.members : {
        role   = role
        member = member
      }
    ]
  ])
}

# Custom Role
resource "google_project_iam_custom_role" "custom-role" {
  for_each    = var.custom_roles
  role_id     = "${each.key}${each.value.name_suffix}"
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}

# Create service accounts
resource "google_service_account" "service-accounts" {
  for_each     = var.service_accounts
  account_id   = each.key
  display_name = each.key
  description  = each.value.description

  depends_on = [
    google_project_iam_custom_role.custom-role
  ]
}

resource "google_service_account_key" "service-account-keys" {
  for_each = {
    for sa_name, sa_object in var.service_accounts :
    sa_name => sa_object
    if sa_object.generate_key
  }
  service_account_id = google_service_account.service-accounts[each.key].name
}

# Grant permissions for list of members
resource "google_project_iam_member" "normal-users" {
  for_each = {
    for role_binding in local.role_bindings : "${role_binding.role}.${role_binding.member}" => role_binding
  }
  role    = each.value.role
  member  = each.value.member
  project = var.project_id
  depends_on = [
    google_service_account.service-accounts
  ]
}


# Grant permissions for list of members with custom role
resource "google_project_iam_member" "normal-users-custom-role" {
  for_each = {
    for custom_role_binding in local.custom_role_bindings : "${custom_role_binding.role}.${custom_role_binding.member}" => custom_role_binding
  }
  role    = google_project_iam_custom_role.custom-role[each.value.role].id
  member  = each.value.member
  project = var.project_id
  depends_on = [
    google_service_account.service-accounts
  ]
}


# Grant permissions for list of members
resource "google_project_iam_member" "sa" {
  for_each = {
    for sa_role_binding in local.sa_role_bindings : "${sa_role_binding.sa_key}.${sa_role_binding.role}" => sa_role_binding
  }
  role    = each.value.role
  member  = "serviceAccount:${each.value.email}"
  project = var.project_id

  depends_on = [
    google_service_account.service-accounts
  ]
}

resource "google_project_iam_member" "sa-custom-role" {
  for_each = {
    for sa_role_binding in local.sa_custom_role_bindings : "${sa_role_binding.sa_key}.${sa_role_binding.role}" => sa_role_binding
  }
  role    = google_project_iam_custom_role.custom-role[each.value.role].id
  member  = "serviceAccount:${each.value.email}"
  project = var.project_id

  depends_on = [
    google_service_account.service-accounts
  ]
}


resource "google_service_account_iam_binding" "sa-iam-binding" {
  for_each = {
    for sa_iam_binding in local.sa_iam_bindings : "${sa_iam_binding.sa_key}.${sa_iam_binding.role}" => sa_iam_binding
  }
  service_account_id = google_service_account.service-accounts[each.value.sa_key].id
  role               = each.value.role
  members            = each.value.members

  depends_on = [
    google_service_account.service-accounts
  ]
}
