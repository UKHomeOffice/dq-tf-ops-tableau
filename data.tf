data "aws_ami" "tableau" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev-*",
    ]
  }

  owners = [
    "self",
  ]
}

data "aws_caller_identity" "current" {}
