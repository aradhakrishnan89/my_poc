resource "aws_autoscaling_group" "jenkins-poc" {
  desired_capacity     = 2
  launch_configuration = "${aws_launch_configuration.jenkins-poc.id}"
  max_size             = 2
  min_size             = 1
  name                 = "jenkins-poc"
  vpc_zone_identifier  = ["${aws_subnet.jenkins-poc.*.id}"]

  tag {
    key                 = "Name"
    value               = "jenkins-poc"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}