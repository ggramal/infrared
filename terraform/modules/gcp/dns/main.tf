resource "google_dns_managed_zone" "zone" {
  name        = var.zone.name
  dns_name    = var.zone.dns_name
  description = var.zone.description
  dnssec_config {
    kind  = "dns#managedZoneDnsSecConfig"
    state = var.zone.dnssec_state
  }
}

resource "google_dns_record_set" "recordset" {
  managed_zone = google_dns_managed_zone.zone.name
  for_each = {
    for record in var.records :
    record.name => record
  }
  name    = "${each.value.name}.${var.zone.dns_name}"
  type    = each.value.type
  rrdatas = each.value.rrdatas
  ttl     = each.value.ttl
}
