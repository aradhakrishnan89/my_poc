
resource "aws_key_pair" "nikhilsshkey" {
    key_name = "ssh-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOsaNmi1splxA2a9RdJP20crtTanX/9LS3OcEBwKgFwKX9MPUX/QH6A8AGHzNA6JLHbOjjDJYWOQhlOj5lBFEJIwqJR77JB/WEB6FxmujR/kOz1r1f9QJdEiwpyU5G425Q+7Stqa9EQj5gOArfIa5a3q8h9eHm3LyIMu3o4hH+xlCho/i8zpP8y1Dk9cxC1UiutLDUEGIwdXlWkDpkRRiB3PAnh23UE4b2jiMD11eXcT/rFiI6QPXw8Oi6Sjkv2vs5h9CEiRwFKvCUowQMJOUceShYoVl2OGcPrKD7aSXadAMq+lP1A7lV0P/m5pPvy5HrxvxdxPHqPDNvsGxh0Zk7 npaa@sjc-1mpolava-lt.corporate.local"
  
}
resource "aws_instance" "master" {
    connection {
        user = "nikhil"
    }
    count = 1
    instance_type = "m5.large"
    ami = "ami-0d03add87774b12c5"
    key_name = "${aws_key_pair.nikhilsshkey.id}"
    vpc_security_group_ids = ["${aws_security_group.jenkins-poc-master.id}"]
    subnet_id = "${aws_subnet.jenkins-poc.*.id[count.index]}"
    associate_public_ip_address = true
    iam_instance_profile = "${aws_iam_instance_profile.jenkins-poc-master.name}" 

    tags = {
    Name = "kubernetesmaster-${count.index+1}"
    kube = "master"
  }
 
}

output "master-ip" {
  value = "${aws_instance.master.*.public_ip}"
}

