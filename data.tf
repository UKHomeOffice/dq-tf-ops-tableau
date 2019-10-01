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
