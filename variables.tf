# --- root/variables.tf ---

variable "region" {
    type = string
    default = "us-east-1"
}
variable "container_ips"{
    type= string
    default = "aws_eks_node_group.eks-node-group[*].id"

}

variable "cluster_name"{
    type = string
    default = "aws_eks_cluster.cg-cluster.name"
    
}