resource "digitalocean_loadbalancer" "main" {
  name   = "rke"
  region = "fra1"

  droplet_tag = "k8s-rke-wo"

  healthcheck {
    port     = 80
    protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 80
    target_port     = 80
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 443
    target_port     = 443
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 8080
    target_port     = 8080
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }

  forwarding_rule {
    entry_port      = 25
    target_port     = 25
    entry_protocol  = "tcp"
    target_protocol = "tcp"
  }
}

output "lb_ip" {
  value = digitalocean_loadbalancer.main.ip
}

resource "cloudflare_record" "lb" {
  zone_id = var.cloudflare_zone_id
  name    = "rke"
  value   = digitalocean_loadbalancer.main.ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "lb_wildcard" {
  zone_id = var.cloudflare_zone_id
  name    = "*.${cloudflare_record.lb.name}"
  value   = cloudflare_record.lb.hostname
  type    = "CNAME"
  proxied = false
}
