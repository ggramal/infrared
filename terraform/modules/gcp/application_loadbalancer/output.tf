output "application_lb" {
  description = "Appliction loadbalancer"
  value = {
    ip = google_compute_global_address.this.address
  }
}
