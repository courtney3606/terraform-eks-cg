variable "container_ips"{
    type= string
}

variable "cluster_name"{
    type = string
    default = aws_eks_cluster.cg-cluster.name
}