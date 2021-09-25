terraform {
  required_providers {
    linode   = {
      source  = "linode/linode"
      version = "1.21.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.1.0"
    }
  }
}

provider "linode" {
  token = var.token
}

provider "scaleway" {
  access_key = var.access_key
  secret_key = var.secret_key
  project_id = var.project_id
  region     = "fr-par"
}