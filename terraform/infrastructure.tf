
variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "API token to access Hetzner's Cloud resources."
}

provider "hcloud" {
  token = var.hcloud_token
}


resource "hcloud_floating_ip" "primary_ip" {
  type              = "ipv4"
  server_id         = hcloud_server.node.id
  delete_protection = true
}

resource "hcloud_firewall" "firewall" {
  name = "firewall"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

data "template_file" "user_data" {
  template = file("cloud_init.yaml")
  vars = {
    host_file = file("nix/host.nix")
  }
}

resource "hcloud_server" "node" {
  name         = "node"
  image        = "ubuntu-22.04"
  datacenter   = "ash-dc1"
  server_type  = "cpx11"
  firewall_ids = [hcloud_firewall.firewall.id]
  user_data    = data.template_file.user_data.rendered
}
