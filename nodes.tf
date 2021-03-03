data "digitalocean_ssh_key" "ondrejsika" {
  name = var.ssh_key_name
}

module "rke-node-masters" {
  source = "./modules/rke-node"
  count  = var.master_node_count

  zone_id  = var.cloudflare_zone_id
  name     = "rke-ma-${count.index}"
  size     = "s-2vcpu-4gb"
  ssh_keys = [data.digitalocean_ssh_key.ondrejsika.id]
  tags     = ["k8s-rke-ma"]
}

module "rke-node-workers" {
  source = "./modules/rke-node"
  count  = var.worker_node_count

  zone_id  = var.cloudflare_zone_id
  name     = "rke-wo-${count.index}"
  size     = "s-2vcpu-4gb"
  ssh_keys = [data.digitalocean_ssh_key.ondrejsika.id]
  tags     = ["k8s-rke-wo"]
}
