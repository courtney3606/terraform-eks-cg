# ---root/providers.tf ----

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.2"
    }
  }
  }
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
} 

provider "aws" {
  region = "us-east-1"
  profile = "CC_user86"
}
