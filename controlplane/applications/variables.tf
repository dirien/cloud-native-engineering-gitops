variable "kubeconfig" {
  default = "../infrastructure/controlplane.yaml"
}

variable "do-token" {
  sensitive = true
}