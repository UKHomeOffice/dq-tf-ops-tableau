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

data "aws_iam_policy" "ops-win-athena" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ops-win-athena-ops-${var.naming_suffix}-dq"
}
