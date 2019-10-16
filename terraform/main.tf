resource "aws_key_pair" "userkey" {
    key_name = "ssh-key"
    public_key = "ssh-rsa AAAAxxxxxxxxxxxxxxxxxxxxx"
  
}

resource "aws_instance" "kubernetes" {
    connection {
        user = "nikhil"
    }
    count = 3
    instance_type = "m5.large"
    ami = "ami-0d03add87774b12c5"
    key_name = "${aws_key_pair.nikhilsshkey.id}"
    vpc_security_group_ids = ["${aws_security_group.main.id}"]
    subnet_id = "${aws_subnet.main.id}"

    tags = {
    Name = "kubernetes-${count.index+1}"
    purpose = "kubernetesdemo"
  }
 
}
output "ip" {
  value = "${aws_eip.kub.*.public_ip}"
}
