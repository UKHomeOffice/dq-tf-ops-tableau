resource "aws_instance" "tableau" {
  count                       = var.namespace == "prod" ? "3" : "1"
  key_name                    = var.key_name
  ami                         = data.aws_ami.tableau.id
  instance_type               = var.namespace == "prod" ? "t3a.xlarge" : "t3a.large"
  vpc_security_group_ids      = [aws_security_group.tableau.id]
  subnet_id                   = aws_subnet.tableau_subnet.id
  private_ip                  = element(var.tableau_deployment_ip, count.index)
  iam_instance_profile        = aws_iam_instance_profile.tableau.id
  associate_public_ip_address = false
  monitoring                  = true

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      user_data,
      ami,
    ]
  }

  tags = {
    Name = "ec2-deployment-${local.naming_suffix}-${count.index}"
  }
}

resource "aws_security_group" "tableau" {
  vpc_id = var.opsvpc_id

  tags = {
    Name = "sg-${local.naming_suffix}"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "TCP"

    cidr_blocks = [
      var.tableau_subnet_cidr_block,
      var.vpc_subnet_cidr_block,
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
