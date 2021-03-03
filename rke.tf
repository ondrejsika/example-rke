resource "rke_cluster" "main" {
  cluster_name   = "rke"
  ssh_agent_auth = true
  dynamic "nodes" {
    for_each = module.rke-node-masters
    content {
      address = nodes.value["droplet"].ipv4_address
      user    = "root"
      role    = ["controlplane", "etcd"]
    }
  }
  dynamic "nodes" {
    for_each = module.rke-node-workers
    content {
      address = nodes.value["droplet"].ipv4_address
      user    = "root"
      role    = ["worker"]
    }
  }
  ingress {
    provider = "none"
  }
}


output "kubeconfig" {
  value     = rke_cluster.main.kube_config_yaml
  sensitive = true
}
