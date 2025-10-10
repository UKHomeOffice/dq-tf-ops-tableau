data "aws_ami" "tableau" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev-265*",
    ]
  }

  owners = [
    "self",
  ]
}

data "aws_ami" "tableau-test" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "dq-ops-win-tab-dev-430*",
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

