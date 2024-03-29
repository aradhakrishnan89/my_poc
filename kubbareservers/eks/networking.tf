# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "available" {}

resource "aws_vpc" "jenkins-poc" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "jenkins-poc",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "jenkins-poc" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.jenkins-poc.id}"

  tags = "${
    map(
     "Name", "jenkins-poc",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "jenkins-poc" {
  vpc_id = "${aws_vpc.jenkins-poc.id}"

  tags = {
    Name = "jenkins-poc"
  }
}

resource "aws_route_table" "jenkins-poc" {
  vpc_id = "${aws_vpc.jenkins-poc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins-poc.id}"
  }
}

resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = "${aws_subnet.jenkins-poc.*.id[count.index]}"
  route_table_id = "${aws_route_table.jenkins-poc.id}"
}