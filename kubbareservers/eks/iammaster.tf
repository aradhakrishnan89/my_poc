resource "aws_iam_role" "jenkins-poc-master" {
  name = "jenkins-poc"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "jenkins-poc-master-AmazonmasterClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${aws_iam_role.jenkins-poc-master.name}"
}

resource "aws_iam_instance_profile" "jenkins-poc-master" {
  name = "jenkins-poc-master"
  role = "${aws_iam_role.jenkins-poc-master.name}"
}