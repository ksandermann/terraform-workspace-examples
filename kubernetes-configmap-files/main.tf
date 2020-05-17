module "kubernetes-configmap" {
  source = "github.com/ksandermann/terraform-module-kubernetes-configmap-files?ref=v0.1"

  configmap_data_directory   = format("%s%s", path.module, "/configfiles")
  configmap_name             = "configfiles001"
  configmap_namespace        = "microservices-dev"
  configmap_data_file_filter = "*.yaml"
  configmap_annotations = {
    deployed_by = "terraform"
  }
  configmap_labels = {
    stage = "dev"
  }

}

provider "azurerm" {
  version = ">=2.10.0"

  environment     = "Public"
  tenant_id       = "superdupersecret"
  subscription_id = "supersecret"

  features {}
}

data azurerm_kubernetes_cluster "this" {
  name                = "myAKS"
  resource_group_name = "MYAKSRG"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.host
  username               = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.username
  password               = data.azurerm_kubernetes_cluster.this.kube_admin_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_admin_config.0.cluster_ca_certificate)
}
