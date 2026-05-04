data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
    count                   = var.az_count
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    
    tags = {
        Name        = "${var.environment}-subnet-${count.index + 1}"
        Environment = var.environment
        "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_subnet" "private" {
    count                   = var.az_count
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + var.az_count)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
    
    tags = {
        Name        = "${var.environment}-subnet-${count.index + 1}"
        Environment = var.environment
        "kubernetes.io/role/internal-elb" = "1"
    }
}

resource "aws_eip" "nat" {
    domain = "vpc"
    
    tags = {
        Name        = "${var.environment}-nat-eip"
        Environment = var.environment
    }  
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public[0].id
    
    tags = {
        Name        = "${var.environment}-nat-gateway"
        Environment = var.environment
    }  
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
}
    
    tags = {
        Name        = "${var.environment}-public-rt"
        Environment = var.environment
    }  
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }

    tags = {
        Name        = "${var.environment}-private-rt"
        Environment = var.environment
    }  
}

resource "aws_route_table_association" "public" {
    count          = var.az_count
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count          = var.az_count
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}