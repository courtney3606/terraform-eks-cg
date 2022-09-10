# ---root/outputs.tf ---

output "cluster_name" {
  value = "aws_eks_cluster.cgcluster.${random_string.random}.name"
  description = "The name of cluster"
}

output "container_ips" {
    value = "aws_eks_node_group.eks-node-group[*].id"
    description = "The IP address of containers"
}