resource "aws_instance" "tableau" {
  count                       = var.namespace == "prod" ? "1" : "2"
  key_name                    = var.key_name
  ami                         = data.aws_ami.tableau.id
  instance_type               = var.namespace == "prod" ? "t3a.xlarge" : "t3a.xlarge"
  vpc_security_group_ids      = [aws_security_group.tableau.id]
  subnet_id                   = aws_subnet.tableau_subnet.id
  private_ip                  = element(var.tableau_deployment_ip, count.index)
  iam_instance_profile        = aws_iam_instance_profile.tableau.id
  associate_public_ip_address = false
  monitoring                  = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Windows-specific settings
  user_data = <<EOF
                        <powershell>
                           # Enable Firewall
                          Set-NetFirewallProfile -All -Enabled True
                          # Enable Firewall logging
                          Set-NetFireWallProfile -Domain -LogBlocked True -LogMaxSize 20000 -LogFileName ‘%systemroot%\system32\LogFiles\Firewall\pfirewall.log’
                          # Disable local Administrator
                          Get-LocalUser | Where-Object {$_.Name -eq "Administrator"} | Disable-LocalUser
                          # Add Instance metadata V2
                          [string]$instance = Invoke-RestMethod -Method GET -Uri http://169.254.169.254/latest/meta-data/instance-id
                          (Edit-EC2InstanceMetadataOption -InstanceId $instance -HttpTokens required -HttpEndpoint enabled).InstanceMetadataOptions
                        </powershell>
                      EOF

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      user_data,
      ami,
    ]
  }

  tags = {
    Name = "tab-dep-${count.index + 1}-${local.naming_suffix}"
  }
}

# test tableau instance, change count to 0 when not in use
# private_ip is based off their being 2 instances in notprod and this resource creating a 3rd instance

resource "aws_instance" "tableau_test" {
  count                       = var.namespace == "prod" ? "0" : "0" # for testing a single instance only
  key_name                    = var.key_name
  ami                         = data.aws_ami.tableau-test.id
  instance_type               = "t3a.large"
  vpc_security_group_ids      = [aws_security_group.tableau.id]
  subnet_id                   = aws_subnet.tableau_subnet.id
  private_ip                  = element(var.tableau_deployment_ip, 2)
  iam_instance_profile        = aws_iam_instance_profile.tableau.id
  associate_public_ip_address = false
  monitoring                  = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  # Windows-specific settings
  user_data = <<EOF
                        <powershell>
                           # Enable Firewall
                          Set-NetFirewallProfile -All -Enabled True
                          # Enable Firewall logging
                          Set-NetFireWallProfile -Domain -LogBlocked True -LogMaxSize 20000 -LogFileName ‘%systemroot%\system32\LogFiles\Firewall\pfirewall.log’
                          # Disable local Administrator
                          Get-LocalUser | Where-Object {$_.Name -eq "Administrator"} | Disable-LocalUser
                          # Add Instance metadata V2
                          [string]$instance = Invoke-RestMethod -Method GET -Uri http://169.254.169.254/latest/meta-data/instance-id
                          (Edit-EC2InstanceMetadataOption -InstanceId $instance -HttpTokens required -HttpEndpoint enabled).InstanceMetadataOptions
                        </powershell>
                      EOF

  # lifecycle {
  #   prevent_destroy = true

  #   ignore_changes = [
  #     user_data,
  #     ami,
  #   ]
  # }

  tags = {
    Name = "tab-dep-test-${count.index + 1}-${local.naming_suffix}"
  }
}


# To be deleted when all Tab Dep machines have been migrated
#resource "aws_instance" "tableau_nineteen" {
#  key_name                    = var.key_name
#  ami                         = data.aws_ami.tableau_nineteen.id
#  instance_type               = var.namespace == "prod" ? "t3a.xlarge" : "t3a.large"
#  vpc_security_group_ids      = [aws_security_group.tableau.id]
#  subnet_id                   = aws_subnet.tableau_subnet.id
#  private_ip                  = var.tableau_nineteen_deployment_ip
#  iam_instance_profile        = aws_iam_instance_profile.tableau.id
#  associate_public_ip_address = false
#  monitoring                  = true
#
#  #lifecycle {
#  #  prevent_destroy = true
#  #
#  #  ignore_changes = [
#  #    user_data,
#  #    ami,
#  #  ]
#  #}
#
#  tags = {
#    Name = "tab-dep-nineteen-${local.naming_suffix}"
#  }
#}

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

  ingress {
    from_port = 135
    to_port   = 135
    protocol  = "TCP"

    cidr_blocks = [
      var.tableau_subnet_cidr_block,
      var.vpc_subnet_cidr_block,
    ]
  }

  ingress {
    from_port = 139
    to_port   = 139
    protocol  = "TCP"

    cidr_blocks = [
      var.tableau_subnet_cidr_block,
      var.vpc_subnet_cidr_block,
    ]
  }

  ingress {
    from_port = 445
    to_port   = 445
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
