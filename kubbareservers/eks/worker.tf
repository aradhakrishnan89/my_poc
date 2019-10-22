resource "aws_instance" "kubworker" {
    connection {
        user = "nikhil"
    }
    count = 2
    instance_type = "m5.large"
    ami = "ami-0d03add87774b12c5"
    key_name = "${aws_key_pair.nikhilsshkey.id}"
    vpc_security_group_ids = ["${aws_security_group.jenkins-poc-worker.id}"]
    subnet_id = "${aws_subnet.jenkins-poc.*.id[count.index]}"
    associate_public_ip_address = true
    iam_instance_profile = "${aws_iam_instance_profile.jenkins-poc-worker.name}" 

    tags = {
    Name = "kubernetesworker-${count.index+1}"
    kube = "master"
  }
 
}

output "worker-ips" {
  value = "${aws_instance.kubworker.*.public_ip}"
}
