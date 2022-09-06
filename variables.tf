# --- root/variables.tf ---

variable "region" {
    type = string
    default = "us-east-1"
}
variable "container_ips"{
    type= string
}

variable "cluster_name"{
    type = string

}