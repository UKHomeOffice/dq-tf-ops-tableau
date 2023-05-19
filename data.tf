data "aws_ami" "tableau" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev- 2023-01-10T16*",
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
      "dq-ops-win-tab-dev-208*",
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

