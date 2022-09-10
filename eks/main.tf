# --- eks/main.tf ---

resource "aws_eks_node_group" "eks-node-group1" {
  cluster_name    = aws_eks_cluster.cgcluster.name
  node_group_name = "eks-node-group1"
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids      = ["aws_subnet.eks-subnet1.id"]
 

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_eks_node_group" "eks-node-group2" {
  cluster_name    = aws_eks_cluster.cgcluster.name
  node_group_name = "eks-node-group2"
  node_role_arn   = aws_iam_role.eks_role.arn
  subnet_ids      =  ["aws_subnet.eks-subnet2.id"]



  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_vpc_endpoint" "ec2-1" {
  vpc_id            = aws_vpc.eks-vpc.id
  service_name      = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.node_group_one.id,
  ]

  private_dns_enabled = false
}

resource "aws_vpc_endpoint_security_group_association" "sg_ec1" {
  vpc_endpoint_id   = aws_vpc_endpoint.ec2-1.id
  security_group_id = aws_security_group.node_group_one.id
}

resource "aws_security_group" "node_group_two" {
  name_prefix = "node_group_two"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "192.168.0.0/16",
    ]
  }
}
resource "aws_vpc_endpoint" "ec2-2" {
  vpc_id            = aws_vpc.eks-vpc.id
  service_name      = "com.amazonaws.us-east-1.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.node_group_two.id,
  ]

  private_dns_enabled = false
}

resource "aws_vpc_endpoint_security_group_association" "sg_ec2" {
  vpc_endpoint_id   = aws_vpc_endpoint.ec2-2.id
  security_group_id = aws_security_group.node_group_two.id
}

resource "aws_iam_role" "eks_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_role.name
}

data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "eks-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"

}
}
resource "aws_subnet" "eks-subnet1" {
  cidr_block        = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8, 1)
  vpc_id            = "aws_vpc.eks-vpc"
  map_public_ip_on_launch = true

  tags = {
      Name = "eks-subnet1"
    
  }
}

resource "aws_subnet" "eks-subnet2" {
  cidr_block        = cidrsubnet(aws_vpc.eks-vpc.cidr_block, 8,2)
  vpc_id            = "aws_vpc.eks-vpc"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-subnet2"
  }
}

resource "aws_internet_gateway" "eks-ig" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "eks-ig"
  }
}

resource "aws_route_table" "eks-rt1" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-ig.id
  }
}
resource "aws_route_table" "eks-rt2" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-ig.id
  }
}
resource "aws_route_table_association" "eks-rta1" {

  subnet_id      = aws_subnet.eks-subnet1.id
  route_table_id = aws_route_table.eks-rt1.id
}
resource "aws_route_table_association" "k8s-acc" {

  subnet_id      = aws_subnet.eks-subnet2.id
  route_table_id = aws_route_table.eks-rt2.id
}


resource "random_string" "random" {
  length           = 8
  special          = false
}

resource "aws_eks_cluster" "cgcluster" {
  name     = "cgcluster- ${random_string.random}"
  role_arn = aws_iam_role.eks_role.arn 

  vpc_config {
    subnet_ids = [aws_subnet.eks-subnet1.id, aws_subnet.eks-subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
} 
output "endpoint" {
  value = aws_eks_cluster.cgcluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cgcluster.certificate_authority[0].data
}
resource "aws_iam_role" "eks_role_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_role_cluster.name
}