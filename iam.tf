resource "aws_iam_role" "tableau" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "Service": "s3.amazonaws.com",
        "Service": "ssm.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "tableau" {
  role       = "${aws_iam_role.tableau.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/ops-win-athena-ops-${var.naming_suffix}-dq"
}

resource "aws_iam_instance_profile" "tableau" {
  role = "${aws_iam_role.tableau.name}"
}
