locals {
  cluster_name = "${replace("${var.child_domain_name}",".","-")}"
}

data "aws_availability_zones" "this" {
  state                   = "available"
}

data "aws_kms_key" "this" {
  key_id = "alias/${local.cluster_name}"
}

data "aws_elasticsearch_domain" "this" {
  domain_name = "${local.cluster_name}"
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:environment"
    values = ["${local.cluster_name}"]
  }
}

data "aws_vpc" "vpn" {
  provider = "aws.vpn"
  filter {
    name   = "tag:Name"
    values = ["${var.vpn_vpc_tag_value}"]
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = "${data.aws_vpc.this.id}"
  filter {
    name   = "tag:Name"
    values = ["${local.cluster_name}-${var.aws_region}*-private"]
  }
}

data "aws_subnet" "this" {
  count = "${length(data.aws_subnet_ids.this.ids)}"
  id    = "${data.aws_subnet_ids.this.ids[count.index]}"
}
