resource "aws_security_group" "lambda" {
  count       = "${length(data.aws_subnet_ids.this.ids) > 0 ? 1 : 0}"
  name        = "${local.cluster_name}-lambda-cleanup-to-elasticsearch"
  description = "${local.cluster_name}-lambda-cleanup-to-elasticsearch"
  vpc_id      = "${data.aws_vpc.this.id}"


  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = "${merge(
            var.tags,
            map("Scope", "${local.cluster_name}-lambda-function-to-elasticsearch"),
            )}"

}
