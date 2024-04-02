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
        docker_zip = filebase64(data.archive_file.docker-files.output_path)
        docker_nix = file("${path.module}/../nix/docker.nix")
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
