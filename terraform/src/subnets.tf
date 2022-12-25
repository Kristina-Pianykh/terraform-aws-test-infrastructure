# resource "aws_subnet" "eu-west-1b" {
#   vpc_id            = var.vpc_id
#   cidr_block        = "172.31.0.0/16"
#   availability_zone = "eu-west-1b"
# }

# resource "aws_subnet" "eu-west-1a" {
#   vpc_id            = var.vpc_id
#   cidr_block        = "172.31.32.0/20"
#   availability_zone = "eu-west-1a"
# }

# resource "aws_subnet" "eu-west-1c" {
#   vpc_id            = var.vpc_id
#   cidr_block        = "172.31.16.0/20"
#   availability_zone = "eu-west-1c"
# }

resource "aws_subnet" "subnet" {

  for_each = var.subnets

  availability_zone       = each.value.availability_zone
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
}
