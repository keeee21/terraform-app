# ========================================== #
# VPC
# ========================================== #
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# Subnet
# ========================================== #
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[split("-", each.key)[1]]
  cidr_block              = each.value
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-${split("-", each.key)[1]}"
    Project = var.project
    Env     = var.environment
    Type    = "Public"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[split("-", each.key)[1]]
  cidr_block              = each.value
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-${split("-", each.key)[1]}"
    Project = var.project
    Env     = var.environment
    Type    = "Private"
  }
}

# ========================================== #
# Route Table
# ========================================== #
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-route-table"
    Project = var.project
    Env     = var.environment
    Type    = "Public"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-route-table"
    Project = var.project
    Env     = var.environment
    Type    = "Private"
  }
}

# ========================================== #
# Route Table Association
# ========================================== #
resource "aws_route_table_association" "public_subnet_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

# ========================================== #
# Internet Gateway
# ========================================== #
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# Route
# ========================================== #
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}