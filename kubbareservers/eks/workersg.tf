resource "aws_security_group" "jenkins-poc-worker" {
  name        = "jenkins-poc-worker"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.jenkins-poc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "jenkins-poc-worker",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "jenkins-poc-worker-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.jenkins-poc-worker.id}"
  source_security_group_id = "${aws_security_group.jenkins-poc-worker.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "jenkins-poc-worker-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.jenkins-poc-worker.id}"
  source_security_group_id = "${aws_security_group.jenkins-poc-master.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "jenkins-poc-ingress-ssh-worker" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate to ssh to worker"
  from_port         = 0
  protocol          = -1
  security_group_id = "${aws_security_group.jenkins-poc-worker.id}"
  to_port           = 22
  type              = "ingress"
}