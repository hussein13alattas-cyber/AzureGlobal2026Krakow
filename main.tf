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


module "managed_identity" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=managed_identity/v1.0.0"
  name = "NewmanagedID"
  resource_group = {
    location = "PolandCentral"
    name     = "rg-user5"
  }
 tags = {
  new = "MI"
 }

}


module "app_service" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  app_service_name = "serkrakowapp"
  app_service_plan_id = module.service_plan.app_service_plan.id
  app_settings = {}
  identity_client_id = module.managed_identity.managed_identity_client_id
  identity_id = module.managed_identity.managed_identity_id
  resource_group = {
    location = "PolandCentral"
    name     = "rg-user5"
  }

}




