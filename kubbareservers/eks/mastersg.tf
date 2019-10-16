resource "aws_security_group" "jenkins-poc-master" {
  name        = "jenkins-poc"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.jenkins-poc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-poc"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "jenkins-poc-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.jenkins-poc-master.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "jenkins-poc-master-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.jenkins-poc-master.id}"
  source_security_group_id = "${aws_security_group.jenkins-poc-worker.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "jenkins-poc-ingress-ssh-master" {
  cidr_blocks       = ["0.0.0.0/32"]
  description       = "Allow workstation to communicate to ssh to master"
  from_port         = 0
  protocol          = -1
  security_group_id = "${aws_security_group.jenkins-poc-master.id}"
  to_port           = 22
  type              = "ingress"
}