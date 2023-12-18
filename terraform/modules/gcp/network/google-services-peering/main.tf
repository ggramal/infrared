resource "google_compute_global_address" "google_managed_subnet" {
  project       = var.vpc.project_id
  name          = "google-managed-services-${var.vpc.name}"
  purpose       = "VPC_PEERING"
  prefix_length = var.peering_net.prefix_length
  address_type  = "INTERNAL"
  network       = var.vpc.self_link
  description   = var.peering_net.description
}

# Creates the peering with the producer network.
resource "google_service_networking_connection" "google_service_peering_connection" {
  network                 = var.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google_managed_subnet.name]
}
