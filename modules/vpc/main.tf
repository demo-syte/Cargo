resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "celery-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count = 2

  vpc_id     = aws_vpc.main.id
  cidr_block = count.index == 0 ? "10.0.1.0/24" : "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  count = length(aws_subnet.subnet)

  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = aws_subnet.subnet[*].id
}
