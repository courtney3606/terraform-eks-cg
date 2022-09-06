variable "container_ips"{
    type= string
    default = "aws_eks_node_group.eks-node-group[*].id"
}

variable "cluster_name"{
    type = string
    default = cg-cluster- ${random_string.random.id}

}