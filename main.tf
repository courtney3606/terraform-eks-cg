# --- root/main.tf ---

module "eks" {
    source = "./eks"
    ip_address = module.eks.ip_address
    cluster_name = module.eks.aws_eks_cluster

}