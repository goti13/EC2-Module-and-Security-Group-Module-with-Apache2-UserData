variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  default = "vpc-0d82ef8de61ca2566"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro" # optional default
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  default = "subnet-045afed399a8859df"
}