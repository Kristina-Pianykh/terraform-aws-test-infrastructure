resource "aws_subnet" "subnet" {

  for_each = var.subnets

  availability_zone       = each.value.availability_zone
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
}
