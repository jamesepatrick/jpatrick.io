
variable "namecheap_key" {
  type        = string
  description = "Your Namecheap key"
}

variable "namecheap_user" {
  type        = string
  description = "The name of the Namecheap user"
}

variable "protonmail_verification" {
  type        = string
  description = "Verification code for Protonmail"
}

variable "protonmail_dkim" {
  type        = string
  description = "Your Protonmail DKIM public key"
}

variable "github_token" {
  type        = string
  description = "Your Github OAuth token"
}

variable "github_owner" {
  type        = string
  description = "The owner of the Github repository"
}

variable "github_name" {
  type        = string
  description = "The name of the Github repository"
}

variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "API token to access Hetzner's Cloud resources."
}

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
