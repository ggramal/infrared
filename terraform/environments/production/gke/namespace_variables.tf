locals {
  namespaces = {
    redis = {
      name = "redis"
    }
    prometheus = {
      name = "prometheus"
    }
    cert-manager = {
      name = "cert-manager"
    }
    konghq = {
      name = "konghq"
    }
    rabbitmq = {
      name = "rabbitmq"
    }
    postgres = {
      name = "postgres"
    }
    external-dns = {
      name = "external-dns"
    }
  }
}
