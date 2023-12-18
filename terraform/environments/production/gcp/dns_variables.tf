locals {
  dns_zones = {
    "${var.gcp_projects.prd.name}" = {
      zone = {
        name     = "${var.gcp_projects.prd.name}"
        dns_name = "prd.${var.company.domain}."
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
