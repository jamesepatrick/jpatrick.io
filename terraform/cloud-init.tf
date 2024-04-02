locals {
  miniflux_env = join("\n",
    [
      "ADMIN_USERNAME=${var.miniflux_admin_user}",
      "ADMIN_PASSWORD=${var.miniflux_admin_pass}",
      "DATABASE_URL=postgres://${var.miniflux_db_user}:${var.miniflux_db_pass}@miniflux_db/miniflux?sslmode=disable",
      "POSTGRES_USER=${var.miniflux_db_user}",
      "POSTGRES_PASSWORD=${var.miniflux_db_pass}",
  ])
}

data "archive_file" "docker-files" {
  type        = "zip"
  source_dir  = "${path.module}/../docker"
  output_path = "${path.module}/../tmp/docker.zip"
}

data "cloudinit_config" "provision" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/../cloud-init/setup.cfg.tftpl", {})
    merge_type   = "list(append)+dict(recurse_list)+str(append)"
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../cloud-init/docker.cfg.tftpl",
      {
        docker_zip   = filebase64(data.archive_file.docker-files.output_path)
        docker_nix   = file("${path.module}/../nix/docker.nix")
        miniflux_env = local.miniflux_env
      }
    )
    merge_type = "list(append)+dict(recurse_list)+str(append)"
  }
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../cloud-init/infect.cfg.tftpl",
      {
        host_nix              = file("${path.module}/../nix/host.nix")
        tailscale_nix         = file("${path.module}/../nix/tailscale.nix")
        tailscale_tailnet_key = tailscale_tailnet_key.prod.key
      }
    )
    merge_type = "list(append)+dict(recurse_list)+str(append)"
  }
}