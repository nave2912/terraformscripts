terraform {
   required_version = ">= 0.11" 
   backend "azurerm" {
     storage_account_name = "<tfstorageaccountname>"
     container_name       = "<containername>"
     key                  = "terraform.tfstate"
 	 access_key  ="__storagekey__"
   features{}
 	}
 	}
   provider "azurerm" {
    version = "~> 2.1.0"
 features {}
 }
 
 resource "azurerm_resource_group" "dev" {
   name     = "powerhub-dev-appservice-rg"
   location = "eastus2"
   tags = {
    DevOwner = "naveenkumar.v@sagentlending.com"
  }
 }

resource "azurerm_storage_account" "dev" {
  name                     = "<appstorageaccountname>"
  location                 = "${azurerm_resource_group.dev.location}"
  resource_group_name      = "${azurerm_resource_group.dev.name}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
    static_website {
    index_document = "index.html"
  }
  tags = {
    DevOwner = "naveenkumar.v@sagentlending.com"
  }
}

 resource "azurerm_app_service_plan" "dev" {
   name                = "<powerhub-dev-appserviceplan>"
   location            = "${azurerm_resource_group.dev.location}"
   resource_group_name = "${azurerm_resource_group.dev.name}"
   kind                = "Linux"
   reserved = true

  sku {
    tier = "Standard"
    size = "S1"
  }
 }

 resource "azurerm_app_service" "dev" {
   name                = "<powerhub-dev-utility-app>"
   location            = "${azurerm_resource_group.dev.location}"
   resource_group_name = "${azurerm_resource_group.dev.name}"
   app_service_plan_id = "${azurerm_app_service_plan.dev.id}"
   tags = {
    DevOwner = "naveenkumar.v@sagentlending.com"
  }
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
    
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "powerhubcontainerregistry.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME = "PowerHubContainerRegistry"
    DOCKER_REGISTRY_SERVER_PASSWORD = "9RWa4UDvsirnwMyGqNaeyucJBq8+qulD"
  }
  identity {
    type = "SystemAssigned"
  }
 }
 
