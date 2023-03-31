data "aws_ami" "tableau" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev-*",
    ]
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      user_data,
      ami,
      instance_type,
    ]
  }

  owners = [
    "self",
  ]
}

data "aws_ami" "tableau_nineteen" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev-180*",
    ]
  }

  owners = [
    "self",
  ]
}

data "aws_kms_key" "glue" {
  key_id = "alias/aws/glue"
}

data "aws_caller_identity" "current" {
}

