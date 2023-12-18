locals {
  dns_zones = {
    "${var.gcp_projects.dev.name}" = {
      zone = {
        name     = "${var.gcp_projects.dev.name}"
        dns_name = "dev.${var.company.domain}."
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
