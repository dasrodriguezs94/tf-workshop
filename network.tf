resource "aws_vpc" "workshop_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "workshop_subnet" {
  vpc_id                  = aws_vpc.workshop_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  # Ensures instances get public IPs
}

resource "aws_internet_gateway" "workshop_igw" {
  vpc_id = aws_vpc.workshop_vpc.id
}

resource "aws_route_table" "workshop_route" {
  vpc_id = aws_vpc.workshop_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.workshop_igw.id
  }
}

resource "aws_route_table_association" "workshop_route_assoc" {
  subnet_id      = aws_subnet.workshop_subnet.id
  route_table_id = aws_route_table.workshop_route.id
}
