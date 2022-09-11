# --- root/main.tf ---

module "eks" {
    source = "./eks"
    container_ips = var.container_ips
    cluster_name = var.cluster_name
    aws_availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f" ]
}