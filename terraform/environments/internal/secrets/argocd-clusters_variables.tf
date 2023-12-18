locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in local.gke_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${data.google_container_cluster.gke_clusters[cluster_name].endpoint}"
        config = <<EOF
{
  "execProviderConfig": {
    "command": "argocd-k8s-auth",
    "args": ["gcp"],
    "apiVersion": "client.authentication.k8s.io/v1beta1"
  },
  "tlsClientConfig": {
    "insecure": false,
    "caData": "${data.google_container_cluster.gke_clusters[cluster_name].master_auth[0].cluster_ca_certificate}"
  }
}
EOF
      }
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {
      }
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
    }
    if cluster_name != "int"
  }
}
