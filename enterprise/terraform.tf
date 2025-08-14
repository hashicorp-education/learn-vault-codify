#-----------------------------------------------------------------------------------
# To configure Transform secrets engine, you need vault provider v2.12.0 or later
#-----------------------------------------------------------------------------------
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.0.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}