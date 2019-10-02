resource "aws_instance" "tableau" {
  key_name                    = "${var.key_name}"
  ami                         = "${data.aws_ami.tableau.id}"
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.tableau.id}"]
  subnet_id                   = "${aws_subnet.tableau_subnet.id}"
  private_ip                  = "${var.tableau_dev_ip}"
  # iam_instance_profile        = "${var.ops-win-iam-role}"
  associate_public_ip_address = false
  monitoring                  = true

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      "user_data",
      "ami",
      "instance_type",
    ]
  }

  tags = {
    Name = "ec2-dev-${local.naming_suffix}"
  }
}

resource "aws_security_group" "tableau" {
  vpc_id = "${var.opsvpc_id}"

  tags = {
    Name = "sg-${local.naming_suffix}"
  }

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "TCP"

    cidr_blocks = [
      "${var.tableau_subnet_cidr_block}",
      "${var.vpc_subnet_cidr_block}"
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
