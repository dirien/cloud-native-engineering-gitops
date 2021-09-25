terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "0.10.11"
    }
  }
}

provider "civo" {
  token  = var.civo_token
  region = "FRA1"
}
resource "civo_kubernetes_cluster" "control-plane" {
  name              = "my-control-plane"
  applications      = "Traefik"
  num_target_nodes  = 1
  target_nodes_size = "g3.k3s.large"
}

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.control-plane.kubeconfig
  filename = "controlplane.yaml"
}

output "argocd-login" {
  value = "argocd login argocd.ediri.online --grpc-web --insecure"
}