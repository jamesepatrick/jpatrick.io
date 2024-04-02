provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "repository" {
  name       = var.github_name
  visibility = "public"
}
