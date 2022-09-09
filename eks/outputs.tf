# ---root/outputs.tf ---

output "cluster_name" {
  value = aws_eks_cluster.cg-cluster.name
  description = "The name of cluster"
}

output "container_ips" {
    value = "aws_eks_node_group.eks-node-group[*].id"
    description = "The IP address of containers"
}