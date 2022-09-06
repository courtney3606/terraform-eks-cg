# --- root/variables.tf ---

variable "region" {
    type = string
    default = "us-east-1"
}
variable "container_ips"{
    type= string
    default = var.container_ips
}

variable "cluster_name"{
    type = string
    default = var.container_ips

}