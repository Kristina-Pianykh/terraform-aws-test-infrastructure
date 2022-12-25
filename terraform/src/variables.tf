variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}


variable "ami_id" {
  description = "Amazon Machine Image for the EC2 Instance"
  type        = string
  default     = "ami-0fe0b2cf0e1f25c8a"
  nullable    = false
}

variable "region" {
  type    = string
  default = "eu-west-1"

}

variable "instance_count" {
  type    = number
  default = 3
}

variable "vpc_id" {
  type    = string
  default = "vpc-08baf641b4aa1f3aa"
}

variable "subnets" {
  default = {
    private-subnet-az-a = {
      cidr_block              = "172.31.32.0/20"
      map_public_ip_on_launch = false
      availability_zone       = "eu-west-1a"
    }
    private-subnet-az-b = {
      cidr_block              = "172.31.0.0/20"
      map_public_ip_on_launch = false
      availability_zone       = "eu-west-1b"
    }
    private-subnet-az-c = {
      cidr_block              = "172.31.16.0/20"
      map_public_ip_on_launch = false
      availability_zone       = "eu-west-1c"
    }
  }
}

variable "health_check_port" {
  type        = number
  default     = 80
  description = "Health Check Port for the Application Load Balancer"
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]

}
