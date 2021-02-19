provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "tf_gr_blobstore"
        storage_account_name = "tfvykistwosa1"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "West Europe"
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}

resource "azurerm_container_group" "tfcg" {
    name = "weatherapi"
    location  = azurerm_resource_group.tf_test.location
    resource_group_name = azurerm_resource_group.tf_test.name

    ip_address_type     = "public"
    dns_name_label      = "vykistwowa"
    os_type             = "Linux"

    container {
      name            = "weatherapi"
      image           = "vykistwo/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}