resource "aws_iam_role" "jenkins-poc-worker" {
  name = "jenkins-poc-worker"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "jenkins-poc-worker-AmazonWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${aws_iam_role.jenkins-poc-worker.name}"
}

resource "aws_iam_instance_profile" "jenkins-poc-worker" {
  name = "jenkins-poc-worker"
  role = "${aws_iam_role.jenkins-poc-worker.name}"
}