
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    porkbun = {
      source  = "cullenmcdermott/porkbun"
      version = ">= 0.2.5"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.44.1"
    }
    tailscale = {
      source = "tailscale/tailscale"
    }
  }
}
