
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


data "cloudinit_config" "provision" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init/setup.cfg.tftpl", {})
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/infect.cfg.tftpl",
      {
        host_file             = file("nix/host.nix")
        tailscale_file        = file("nix/tailscale.nix")
        tailscale_tailnet_key = tailscale_tailnet_key.prod.key
      }
    )
  }
}

resource "hcloud_server" "node" {
  name         = "node"
  image        = "ubuntu-22.04"
  datacenter   = "ash-dc1"
  server_type  = "cpx11"
  firewall_ids = [hcloud_firewall.firewall.id]
  user_data    = data.cloudinit_config.provision.rendered
}

resource "hcloud_volume" "data" {
  name              = "data"
  size              = 10 #size in GB. Min is 10
  server_id         = hcloud_server.node.id
  automount         = true
  format            = "ext4"
  delete_protection = true
}
