variable "region" {
  description = "region to create instances"
  default = "us-east-2"
}
variable "vpc_id" {
  default = "10.0.0.0/16"
}
variable "subnet_id" {
    type = "list"
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
}
#variable "azs" {
#    type = "list"
#    default = ["us-east-1a","us-east-1b","us-east-1c", "us-east-1d"]
  


