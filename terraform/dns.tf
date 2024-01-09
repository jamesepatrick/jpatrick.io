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

data "http" "external_ip" {
  url = "http://ipv4.icanhazip.com"
}

provider "namecheap" {
  user_name   = var.namecheap_user
  api_user    = var.namecheap_user
  api_key     = var.namecheap_key
  client_ip   = chomp(data.http.external_ip.response_body)
  use_sandbox = false
}

resource "namecheap_domain_records" "jpatrick-io" {
  domain = "jpatrick.io"
  mode   = "MERGE"

  record {
    hostname = "@"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "calendar"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "cloud"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "git"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "pops"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "rss"
    type     = "A"
    address  = "159.89.245.134"
  }
  record {
    hostname = "traefik"
    type     = "A"
    address  = "159.89.245.134"
  }
}


resource "namecheap_domain_records" "jpatrick-io-mail" {
  domain     = "jpatrick.io"
  mode       = "MERGE"
  email_type = "MX"

  record {
    hostname = "@"
    type     = "MX"
    address  = "mail.protonmail.ch."
    mx_pref  = 10
  }
  record {
    hostname = "@"
    type     = "TXT"
    address  = "protonmail-verification=${var.protonmail_verification}"
  }
  record {
    hostname = "@"
    type     = "TXT"
    address  = "v=spf1 include:_spf.protonmail.ch mx ~all"
  }
  record {
    hostname = "protonmail._domainkey"
    type     = "TXT"
    address  = "v=DKIM1; k=rsa; p=${var.protonmail_dkim}"
  }
}
