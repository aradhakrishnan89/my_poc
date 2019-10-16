resource "aws_eks_cluster" "jenkins-poc" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.jenkins-poc-master.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.jenkins-poc-master.id}"]
    subnet_ids         = ["${aws_subnet.jenkins-poc.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.jenkins-poc-master-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.jenkins-poc-master-AmazonEKSServicePolicy",
  ]
}