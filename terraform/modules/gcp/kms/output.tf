output "keys" {
  value = {
    for key_name, key_obj in google_kms_crypto_key.keys :
    key_name => key_obj
  }
}
