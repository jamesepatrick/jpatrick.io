
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    namecheap = {
      source  = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.44.1"
    }
  }
}
