locals {
  naming_suffix = "tableau-${var.naming_suffix}"
}

resource "aws_subnet" "tableau_subnet" {
  vpc_id                  = var.opsvpc_id
  cidr_block              = var.tableau_subnet_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = var.az

  tags = {
    Name = "subnet-${local.naming_suffix}"
  }
}

resource "aws_route_table_association" "tableau_subnet" {
  subnet_id      = aws_subnet.tableau_subnet.id
  route_table_id = var.route_table_id
}

