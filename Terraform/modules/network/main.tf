resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.env_name}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id 
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.env_name}-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id 
  tags = {
    Name = "${var.env_name}-main-igw"
  }
}

resource "aws_eip" "nat" {
  tags = {
    Name = "${var.env_name}-nat-eip"
  }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id 
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "${var.env_name}--nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

#ROUTE TABLES

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
  tags = {
    Name = "${var.env_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id 
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id 
  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.env_name}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


# SECURITY GROUPS 

resource "aws_security_group" "web_sg" {
  name = "web-sg"
  vpc_id = aws_vpc.main.id 
  description = "allow HTTP annd HTTPS"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-web-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name = "db_sg"
  vpc_id = aws_vpc.main.id 
  description = "Allow PostgradeSQL acces from web server"

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-db-sg"
  }
}
