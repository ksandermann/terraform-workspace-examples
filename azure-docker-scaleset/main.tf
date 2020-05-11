module "composer" {
  source = "github.com/ksandermann/terraform-module-azure-docker-scaleset?ref=v0.1"

  //mandatory
  //generic
  subscription_id          = "supersecrret"
  location                 = "westeurope"
  vnet_name                = "NET001"
  vnet_rg_name             = "RG001"
  loadbalancer_subnet_name = "NET001RIM001"
  scaleset_subnet_name     = "NET001SPOKE001"

  //loadbalancer
  loadbalancer_name    = "nginxLB001"
  loadbalancer_rg_name = "RG002"

  //scaleset
  scaleset_name          = "nginxSS001"
  scaleset_rg_name       = "RG003"
  scaleset_admin_ssh_key = "ssh-rsaSUPERSECRET"

  //containers
  loadbalancer_healthprobe_port = 80
  docker_compose_file_b64       = base64encode(file("./configfiles/docker-compose.yaml"))
  container_config_files = {
    conf = {
      host_path        = "/etc/composer/nginx.conf"
      file_content_b64 = base64encode(file("./configfiles/nginx.conf"))
    },
    index001 = {
      host_path        = "/etc/composer/index001.html"
      file_content_b64 = base64encode(file("./configfiles/index001.html"))
    },
    index002 = {
      host_path        = "/etc/composer/index002.html"
      file_content_b64 = base64encode(file("./configfiles/index002.html"))
    }
  }
  loadbalancer_ports = {
    http001 = {
      port     = 80
      protocol = "Tcp"
    },
    http002 = {
      port     = 8080
      protocol = "Tcp"
    },
  }

  //optional
  scaleset_boot_diagnostics_enabled                 = true
  scaleset_boot_diagnostics_storage_account_rg_name = "RG001"
  scaleset_boot_diagnostics_storage_account_name    = "STA001"
}
