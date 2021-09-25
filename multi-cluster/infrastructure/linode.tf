resource "linode_lke_cluster" "linode-cluster" {
  label       = "linode-cluster"
  k8s_version = "1.21"
  region      = "eu-central"
  tags        = ["cluster-2", "meetup"]

  pool {
    type  = "g6-standard-2"
    count = 1
  }
}

resource "local_file" "linode-kubeconfig" {
  content  = base64decode(linode_lke_cluster.linode-cluster.kubeconfig)
  filename = "linode.yaml"
}