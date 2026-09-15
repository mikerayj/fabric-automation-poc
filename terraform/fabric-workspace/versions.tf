terraform {
  required_version = ">= 1.8, < 2.0"

  required_providers {
    fabric = {
      source  = "microsoft/fabric"
      version = "~> 1.13"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Credentials are never set in code. Configure the provider through the
# FABRIC_* environment variables (Azure CLI locally, OIDC in GitHub Actions).
provider "fabric" {}
