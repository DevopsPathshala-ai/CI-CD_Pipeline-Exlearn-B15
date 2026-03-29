variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for Public Subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for Private Subnet"
  type        = string
  default     = "10.1.2.0/24"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
