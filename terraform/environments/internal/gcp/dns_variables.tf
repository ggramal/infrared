locals {
  dns_zones = {
    "${var.gcp_projects.int.name}" = {
      zone = {
        name     = "${var.gcp_projects.int.name}"
        dns_name = "int.${var.company.domain}."
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
