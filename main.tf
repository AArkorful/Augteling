resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block       = var.aws_vpc-Prod-rock-VPC
  instance_tenancy = "default"

  tags = {
    Name = "Prod-rock-VPC"
  }
}

resource "aws_subnet" "Test-public-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.aws_subnet-Test-public-sub1

  tags = {
    Name = "Test-public-sub1"
  }
}

resource "aws_subnet" "Test-public-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.aws_subnet-Test-public-sub2

  tags = {
    Name = "Test-public-sub2"
  }
}

resource "aws_subnet" "Test-priv-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.aws_subnet-Test-priv-sub1

  tags = {
    Name = "Test-priv-sub1"
  }
}

resource "aws_subnet" "Test-priv-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.aws_subnet-Test-priv-sub2

  tags = {
    Name = "Test-priv-sub2"
  }
}

resource "aws_route_table" "Test-pub-route-table"{
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-pub-route-table"
  }
}

resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-priv-route-table"
  }
}

resource "aws_route_table_association" "public-route-association" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

resource "aws_route_table_association" "private-route-association" {
  subnet_id      = aws_subnet.Test-priv-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id
}

# Elastic IP#
resource "aws_eip" "EIP_for_NGW" {
vpc                        = true
associate_with_private_ip  = "13.41.117.164"
depends_on                 = [aws_internet_gateway.Test-igw]
}

# NAT Gateway #
resource "aws_nat_gateway" "Prod_NGW" {
  allocation_id = aws_eip.EIP_for_NGW.id
  subnet_id     = aws_subnet.Test-public-sub1.id

  tags = {
    Name = "Prod.NGW"
  }
}

# attaching NGW to the private route table #

resource "aws_route" "Test-ngw" {
  route_table_id         = aws_route_table.Test-priv-route-table.id
  gateway_id             = aws_nat_gateway.Prod_NGW.id
  destination_cidr_block = "0.0.0.0/0"
}


# Security groups #
resource "aws_security_group" "Test-sec-group" {
  name        = "Rock-SG"
  description = var.aws_security_group-Test-sec-group
  vpc_id      = aws_vpc.Prod-rock-VPC.id

  ingress {
    description      = "allow http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["41.242.136.70/32"]
  }

  ingress {
    description      = "allow ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security group for ec2"
  }
}

# ec2 Instance #
resource "aws_instance" "test-sever-1" {
  ami             = "ami-0be590cb7a2969726"
  instance_type   = "t2.micro"
  key_name               = "mainkeypair"
  subnet_id       = aws_subnet.Test-public-sub1.id
  tenancy         = "default"

  tags = {
    Name = "test-sever-1"
  }
}

resource "aws_instance" "test-sever-2" {
  ami             = "ami-0be590cb7a2969726"
  instance_type   = "t2.micro"
  key_name               = "mainkeypair"
  subnet_id       = aws_subnet.Test-public-sub2.id
  tenancy         = "default"

  tags = {
    Name = "test-sever-2"
  }
}