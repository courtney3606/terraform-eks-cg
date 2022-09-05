# --- root/main.tf ---

module "eks" {
    source = "./eks"
    vpc_id = var.vpc_id
}