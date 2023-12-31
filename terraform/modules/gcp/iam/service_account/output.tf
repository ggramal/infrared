output "service_account" {
  description = "Service account object"
  value = merge(
    google_service_account.this,
    {
      key = var.generate_key ? google_service_account_key.this[0].private_key : ""
    }
  )
}
