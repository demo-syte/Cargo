variable "vpc_name" {
  type = string
   default = "celery_vpc"
}

variable "vpc-cidr" {
    default = "10.0.0.0/16"
  
}

variable "privatesubnet1" {
    default = "10.0.1.0/24"
  
}

variable "privatesubnet2" {
    default = "10.0.2.0/24"
  
}

variable "rds-subnet" {
    default = "10.0.7.0/24"
  
}

#public subnets
variable "publicsubnet1" {
    default = "10.0.11.0/24"
  
}

variable "publicsubnet2" {
    default = "10.0.12.0/24"
  
}