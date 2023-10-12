variable "subnets" {
  description = "Subnets for the EKS cluster"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name"
  default     = "cargo"
}
