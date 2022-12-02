# creating region
variable "region" {
    default = "eu-west-2" 
    description = "AWS-region"
}

# creating vpc components
variable "aws_vpc-Prod-rock-VPC" {
    default     = "10.0.0.0/16"
    description = "Prod-rock-VPC-cidr_block"
}

# creating public subnet components
variable "aws_subnet-Test-public-sub1" {
    default     = "10.0.1.0/24"
    description = "Test-public-sub1"
}

variable "aws_subnet-Test-public-sub2" {
    default     = "10.0.2.0/24"
    description = "Test-public-sub2"
}

# creating private subnet components
variable "aws_subnet-Test-priv-sub1" {
    default     = "10.0.3.0/24"
    description = "Test-priv-sub1"
}

variable "aws_subnet-Test-priv-sub2" {
    default     = "10.0.4.0/24"
    description = "Test-priv-sub2"
}
# creating security group #
variable "aws_security_group-Test-sec-group" {
    default     = "Allow traffic from port 80 to port 22"
    description = "aws_security_group-Test-sec-group"
}




