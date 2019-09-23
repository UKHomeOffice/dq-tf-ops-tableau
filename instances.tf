resource "aws_instance" "tableau" {
  key_name                    = "${var.key_name}"
  ami                         = "${data.aws_ami.tableau.id}"
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.tableau.id}"]
  subnet_id                   = "${aws_subnet.tableau_subnet.id}"
  private_ip                  = "${var.tableau_dev_ip}"
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

resource "aws_ebs_volume" "tableau_volume" {
  size                     =   500
  availability_zone        =   "eu-west-2a"
  type                     =   "gp2"
  encrypted                =   true
  kms_key_id               =   "${data.aws_kms_key.ebs_kms_key.id}"
}

resource "aws_volume_attachment" "attached_tableau_volume" {
  device_name     =   "/dev/sda1"
  volume_id       =   "${aws_ebs_volume.tableau_volume.id}"
  instance_id     =   "${aws_instance.tableau.id}"
  skip_destroy    =   true
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
