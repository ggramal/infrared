locals {
  gke_clusters = {
    prd = {
      name               = "prd"
      regional           = true
      region             = var.gcp_projects.prd.region
      zones              = data.google_compute_zones.available.names
      kubernetes_version = "latest"

      subnetwork              = module.gcp.subnets["main"]["${var.gcp_projects.prd.region}/vms"].name
      network                 = module.gcp.vpcs["main"].network_name
      network_policy          = true
      network_policy_provider = "CALICO"
      ip_range_pods           = module.gcp.subnets["main"]["${var.gcp_projects.prd.region}/vms"].secondary_ip_range[0].range_name
      ip_range_services       = module.gcp.subnets["main"]["${var.gcp_projects.prd.region}/vms"].secondary_ip_range[1].range_name

      http_load_balancing             = true
      horizontal_pod_autoscaling      = true
      create_service_account          = false
      enable_vertical_pod_autoscaling = true
      enable_shielded_nodes           = false
      remove_default_node_pool        = true
      authenticator_security_group    = "gke-security-groups@defigang.dev"
      identity_namespace              = "enabled"
      node_metadata                   = "GKE_METADATA"

      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"

      resource_usage_export_dataset_id   = ""
      enable_network_egress_export       = false
      enable_resource_consumption_export = false

      maintenance_start_time = "2020-02-07T06:00:00Z"
      maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA"
      maintenance_end_time   = "2020-02-07T18:00:00Z"

      cluster_resource_labels = {
        "env" = "prd"
      }
      master_authorized_networks = [
        for authNetKey, authNetObj in local.networks["main"].authorized_networks :
        {
          cidr_block   = authNetObj.cidr_block
          display_name = authNetObj.display_name
        }
      ]

      master_global_access_enabled = false # We use public endpoint for master access so setting false to ignore
      node_pools = [
        {
          name         = "apps-spot"
          machine_type = "custom-4-16384"
          node_locations = join(
            ",",
            data.google_compute_zones.available.names,
          )
          min_count          = 0
          max_count          = 10
          local_ssd_count    = 0
          disk_size_gb       = 70
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${var.gcp_projects.prd.name}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = true
          initial_node_count = 1
        },
        {
          name         = "apps-on-demand"
          machine_type = "e2-custom-4-16384"
          node_locations = join(
            ",",
            slice(
              data.google_compute_zones.available.names,
              0,
              2
            )
          )
          min_count          = 1
          max_count          = 10
          local_ssd_count    = 0
          disk_size_gb       = 70
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${var.gcp_projects.prd.name}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = false
          initial_node_count = 1
        },
      ]

      node_pools_oauth_scopes = {
        all = []
        #All k8s permissions for nodes
        #are set on serviceaccount level
        #not by using oauth scopes. This
        #scopes are default ones
        apps-spot = [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
        apps-on-demand = [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }

      node_pools_labels = {
        all = {}

        #Ugly hack in order to remove the default values
        default_values = {
          cluster_name = false
          node_pool    = false
        }
        apps-spot = {
          apps-spot = "true"
        }
        apps-on-demand = {
          apps-on-demand = "true"
        }
      }

      node_pools_metadata = {
        all = {}

        #Ugly hack in order to remove the default values
        default_values = {
          cluster_name = false
          node_pool    = false
        }
      }

      node_pools_taints = {
        all = []
        apps-spot = [
          {
            key    = "apps-spot"
            value  = true
            effect = "NO_SCHEDULE"
          },
        ]
      }

      node_pools_tags = {
        all = []
        #Ugly hack in order to remove the default values
        default_values = [
          false,
          false,
          false
        ]
      }
    }
  }
}
