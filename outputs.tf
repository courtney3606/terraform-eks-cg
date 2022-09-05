# ---root/outputs.tf ---

output "cluster_name" {
  value = aws_eks_cluster.cg-cluster.name
  description = "The name of cluster"
}

output "IP-address" {
    value = module.eks[*].ip_address
    description = "The IP address of containers"
}