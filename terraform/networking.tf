resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_id}"
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"

}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.main.default_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
}

data "aws_instances" "ec2-kube" {
  instance_tags = {
    purpose = "kubernetesdemo"
  }

  instance_state_names = ["running"]
}

resource "aws_eip" "kub" {
  count    = "${length(data.aws_instances.ec2-kube.ids)}"
  instance = "${data.aws_instances.ec2-kube.ids[count.index]}"
}