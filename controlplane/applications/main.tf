terraform {
  required_providers {
    helm       = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.5.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../infrastructure/${var.kubeconfig}"
  }
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  config_path = "../infrastructure/${var.kubeconfig}"
}

resource "helm_release" "external-dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  create_namespace = true
  version          = "1.2.0"
  namespace        = "external-dns"
  values           = [
    templatefile("external-dns.yaml", {
      do-token = var.do-token
    })
  ]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  create_namespace = true
  namespace        = "cert-manager"
  version          = "1.5.3"
  set {
    name  = "installCRDs"
    value = true
  }
}

resource "kubernetes_manifest" "issuer" {
  manifest   = yamldecode(file("cluster-issuer-staging.yaml"))
  depends_on = [
    helm_release.cert-manager
  ]
}

resource "helm_release" "argo" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
  version          = "3.21.0"
  values           = [
    file("argo.yaml")
  ]
}
resource "helm_release" "argocd-applicationset" {
  name       = "argocd-applicationset"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-applicationset"
  namespace  = "argocd"
  version    = "1.4.0"
  set {
    name  = "rbac.pspEnabled"
    value = false
  }
  depends_on = [
    helm_release.argo
  ]
}
