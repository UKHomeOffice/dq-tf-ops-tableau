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

data "aws_iam_policy" "ops-win-athena" {
  name = "ops-win-athena-ops-${var.naming_suffix}-dq"
}
