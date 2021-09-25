terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
  }
}

variable "kubeconfig" {}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  config_path = var.kubeconfig
}


resource "kubernetes_manifest" "podtato-head" {
  manifest = yamldecode(file("podtato-head.yaml"))

}

resource "kubernetes_manifest" "app-of-apps-pattern" {
  manifest = yamldecode(file("app-of-apps-pattern.yaml"))
}


