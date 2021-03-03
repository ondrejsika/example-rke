variable "zone_id" {}
variable "name" {}
variable "size" {}
variable "ssh_keys" {}
variable "tags" {}

resource "digitalocean_droplet" "main" {
  image     = "docker-18-04"
  name      = var.name
  region    = "fra1"
  size      = var.size
  ssh_keys  = var.ssh_keys
  tags      = var.tags
  user_data = <<-EOT
    #!/bin/sh
    ufw disable
  EOT
}

resource "cloudflare_record" "main" {
  zone_id = var.zone_id
  name    = var.name
  value   = digitalocean_droplet.main.ipv4_address
  type    = "A"
  proxied = false
}

output "droplet" {
  value = digitalocean_droplet.main
}

output "record" {
  value = cloudflare_record.main
}
