locals {
  secrets = merge(
    local.prometheus,
    local.grafana,
    local.argocd-clusters,
    local.argocd-repos,
  )
}
