terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-user5"
    storage_account_name = "poluser321"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  keyvault_name = "Kluczvoluta0123"

 resource_group = {
    location = "PolandCentral"
    name     = "rg-user5"
  }

network_acls = {
 bypass = "AzureServices"

}

}

module "service_plan" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  app_service_plan_name = "Serviceplanresource"
  resource_group = {
    location = "PolandCentral"
    name     = "rg-user5"
  }
  sku_name = "B3"
  tags = {
    environment = "SP"
  }

}

module "app_service" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  app_service_name = "serkrakowapp"
  app_service_plan_id = module.service_plan.app_service_plan.id
  app_settings = {}
  identity_client_id = "82e6e687-206b-46b8-9301-2d09fd20816a"
  identity_id = "/subscriptions/4c569ea4-8bfc-4063-9557-390e4b28a153/resourcegroups/rg-user5/providers/Microsoft.ManagedIdentity/userAssignedIdentities/managedIdentity"
  resource_group = {
    location = "PolandCentral"
    name     = "rg-user5"
  }






}
