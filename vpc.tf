# VPC y Redes
resource "aws_vpc" "vpc_gonzalez" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "vpc-${var.project_name}" }
}

# Subredes Públicas para ALB
resource "aws_subnet" "public_1_gonzalez" {
  vpc_id                  = aws_vpc.vpc_gonzalez.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "pub-1-${var.project_name}" }
}

resource "aws_subnet" "public_2_gonzalez" {
  vpc_id                  = aws_vpc.vpc_gonzalez.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = { Name = "pub-2-${var.project_name}" }
}

# Subredes Privadas para Fargate
resource "aws_subnet" "private_1_gonzalez" {
  vpc_id            = aws_vpc.vpc_gonzalez.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  tags = { Name = "priv-1-${var.project_name}" }
}

resource "aws_subnet" "private_2_gonzalez" {
  vpc_id            = aws_vpc.vpc_gonzalez.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  tags = { Name = "priv-2-${var.project_name}" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_gonzalez" {
  vpc_id = aws_vpc.vpc_gonzalez.id
  tags   = { Name = "igw-${var.project_name}" }
}

# NAT Gateway (requerido para que Fargate en subredes privadas acceda a ECR)
resource "aws_eip" "nat_eip_gonzalez" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_gonzalez]
  tags       = { Name = "eip-nat-${var.project_name}" }
}

resource "aws_nat_gateway" "nat_gonzalez" {
  allocation_id = aws_eip.nat_eip_gonzalez.id
  subnet_id     = aws_subnet.public_1_gonzalez.id
  tags          = { Name = "nat-gw-${var.project_name}" }
}

# Tablas de Ruteo
resource "aws_route_table" "public_rt_gonzalez" {
  vpc_id = aws_vpc.vpc_gonzalez.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_gonzalez.id
  }
  tags = { Name = "rt-pub-${var.project_name}" }
}

resource "aws_route_table" "private_rt_gonzalez" {
  vpc_id = aws_vpc.vpc_gonzalez.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gonzalez.id
  }
  tags = { Name = "rt-priv-${var.project_name}" }
}

# Asociaciones de Tablas de Ruteo
resource "aws_route_table_association" "pub_1" {
  subnet_id      = aws_subnet.public_1_gonzalez.id
  route_table_id = aws_route_table.public_rt_gonzalez.id
}

resource "aws_route_table_association" "pub_2" {
  subnet_id      = aws_subnet.public_2_gonzalez.id
  route_table_id = aws_route_table.public_rt_gonzalez.id
}

resource "aws_route_table_association" "priv_1" {
  subnet_id      = aws_subnet.private_1_gonzalez.id
  route_table_id = aws_route_table.private_rt_gonzalez.id
}

resource "aws_route_table_association" "priv_2" {
  subnet_id      = aws_subnet.private_2_gonzalez.id
  route_table_id = aws_route_table.private_rt_gonzalez.id
}
