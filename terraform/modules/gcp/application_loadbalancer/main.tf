resource "google_compute_global_address" "this" {
  name = "${var.name}-alb-address"
}

resource "google_compute_global_forwarding_rule" "https" {
  name = "${var.name}-https-fwdrule"

  target                = google_compute_target_https_proxy.this.id
  port_range            = var.https_target.port_range
  load_balancing_scheme = var.http_target.load_balancing_scheme
  ip_address            = google_compute_global_address.this.address
}

resource "google_compute_global_forwarding_rule" "http" {
  name = "${var.name}-http-fwdrule"

  target                = google_compute_target_http_proxy.this.id
  port_range            = var.http_target.port_range
  load_balancing_scheme = var.http_target.load_balancing_scheme
  ip_address            = google_compute_global_address.this.address
}

resource "google_compute_target_https_proxy" "this" {
  name = "${var.name}-https-proxy"

  url_map          = google_compute_url_map.this["https"].id
  ssl_certificates = [google_compute_managed_ssl_certificate.this.id]
}

resource "google_compute_target_http_proxy" "this" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.this["http"].id
}

resource "google_compute_managed_ssl_certificate" "this" {
  name = "${var.name}-cert"
  managed {
    domains = var.https_target.cert_domains
  }
}

resource "google_compute_backend_service" "this" {
  for_each = var.backends
  name     = "${var.name}-${each.key}"

  protocol              = each.value.protocol
  port_name             = each.value.port_name
  timeout_sec           = each.value.timeout_sec
  load_balancing_scheme = each.value.load_balancing_scheme

  backend {
    group = each.value.backend.group
  }
}


resource "google_compute_url_map" "this" {
  for_each = {
    http  = var.http_target,
    https = var.https_target
  }
  name            = "${var.name}-urlmap-${each.key}"
  default_service = each.value.default_backend_name == null ? null : google_compute_backend_service.this[each.value.default_backend_name].id

  dynamic "host_rule" {
    for_each = each.value.rules
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.key
    }
  }
  dynamic "default_url_redirect" {
    for_each = each.value.default_url_redirect == null ? [] : [
      each.value.default_url_redirect
    ]

    content {
      https_redirect         = default_url_redirect.value.https_redirect
      redirect_response_code = default_url_redirect.value.redirect_response_code
      strip_query            = default_url_redirect.value.strip_query
      host_redirect          = default_url_redirect.value.host_redirect
      path_redirect          = default_url_redirect.value.path_redirect
    }
  }

  dynamic "path_matcher" {
    for_each = each.value.rules
    content {
      name            = path_matcher.key
      default_service = google_compute_backend_service.this[path_matcher.value.default_backend_name].id
      dynamic "route_rules" {
        for_each = path_matcher.value.route_rules == null ? [] : path_matcher.value.route_rules
        content {
          priority = route_rules.value.priority
          service  = google_compute_backend_service.this[route_rules.value.backend_name].id
          dynamic "header_action" {
            for_each = route_rules.value.header_action == null ? {} : {
              "header_action" = route_rules.value.header_action
            }
            content {
              dynamic "response_headers_to_add" {
                for_each = header_action.value.response_headers_to_add == null ? {} : header_action.value.response_headers_to_add
                content {
                  header_name  = response_headers_to_add.key
                  header_value = response_headers_to_add.value
                  replace      = true
                }
              }
            }
          }
          dynamic "match_rules" {
            for_each = route_rules.value.match_rules
            content {
              prefix_match = match_rules.value.prefix_match
              regex_match  = match_rules.value.regex_match
            }
          }
        }
      }
      dynamic "path_rule" {
        for_each = path_matcher.value.path_rules == null ? [] : path_matcher.value.path_rules
        content {
          service = google_compute_backend_service.this[path_rule.value.backend_name].id
          paths   = path_rule.value.paths
          dynamic "route_action" {
            for_each = path_rule.value.route_action == null ? {} : {
              "route_action" = path_rule.value.route_action
            }
            content {
              dynamic "cors_policy" {
                for_each = route_action.value.cors == null ? {} : {
                  "cors_policy" = route_action.value.cors
                }
                content {
                  allow_credentials = cors_policy.value.allow_credentials
                  allow_headers     = cors_policy.value.allow_headers
                  allow_origins     = cors_policy.value.allow_origins
                  max_age           = cors_policy.value.max_age
                  allow_methods     = cors_policy.value.allow_methods
                  disabled          = cors_policy.value.disabled
                }
              }
            }
          }
        }
      }
    }
  }
}

