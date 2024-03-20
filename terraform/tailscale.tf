variable "tailscale_token" {
  sensitive   = true
  type        = string
  description = "API token to access Hetzner's Cloud resources."
}

variable "tailscale_tailnet" {
  sensitive   = true
  type        = string
  description = "API token to access Hetzner's Cloud resources."
}

provider "tailscale" {
  api_key = var.tailscale_token
  tailnet = var.tailscale_tailnet
}

resource "tailscale_tailnet_key" "prod" {
  reusable      = false
  ephemeral     = false
  preauthorized = true
  tags          = ["tag:prod"]
}
