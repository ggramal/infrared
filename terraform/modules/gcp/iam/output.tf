output "service_accounts" {
  value = {
    for sa_name, sa_obj in google_service_account.service-accounts :
    sa_name => merge(
      sa_obj,
      {
        key = var.service_accounts[sa_name].generate_key ? google_service_account_key.service-account-keys[sa_name].private_key : ""
      }
    )
  }
}
