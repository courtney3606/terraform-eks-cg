# --- root/main.tf ---

module "eks" {
    source = "./eks"
    container_ips = var.container_ips
    cluster_name = var.cluster_name
}