data "aws_ami" "tableau" {
  most_recent = true

  filter {
    name = "name"

    values = [
      var.environment == "prod" ? "dq-ops-win-tab-dev-265*" : "dq-ops-win-tab-dev-422*",
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

