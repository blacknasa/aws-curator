resource "aws_lambda_function" "es_cleanup_vpc" {
  count            = "${length(data.aws_subnet_ids.this.ids) > 0 ? 1 : 0}"
  filename         = "es-cleanup.zip"
  function_name    = "${local.cluster_name}-es-cleanup"
  description      = "${local.cluster_name}-es-cleanup"
  timeout          = 300
  runtime          = "python${var.python_version}"
  role             = "${aws_iam_role.role.arn}"
  handler          = "es-cleanup.lambda_handler"
  source_code_hash = "${base64sha256(file("es-cleanup.zip"))}"

  environment {
    variables = {
      es_endpoint  = "${data.aws_elasticsearch_domain.this.endpoint}"
      index        = "${var.index}"
      delete_after = "${var.delete_after}"
      index_format = "${var.index_format}"
      sns_alert    = "${var.sns_alert}"
    }
  }

  tags = "${merge(
            var.tags,
            map("Scope", "${var.prefix}lambda_function_to_elasticsearch"),
            )}"
  # This will be a code block with empty lists if we don't create a securitygroup and the subnet_ids are empty.
  # When these lists are empty it will deploy the lambda without VPC support.
  vpc_config {
    subnet_ids         = ["${data.aws_subnet.this.*.id}"]
    security_group_ids = ["${aws_security_group.lambda.id}"]
  }
}



resource "aws_lambda_function" "es_cleanup" {
  count            = "${length(data.aws_subnet_ids.this.ids) == 0 ? 1 : 0}"
  filename         = "es-cleanup.zip"
  function_name    = "${local.cluster_name}-es-cleanup"
  description      = "${local.cluster_name}-es-cleanup"
  timeout          = 300
  runtime          = "python${var.python_version}"
  role             = "${aws_iam_role.role.arn}"
  handler          = "es-cleanup.lambda_handler"
  source_code_hash = "${base64sha256(file("es-cleanup.zip"))}"

  environment {
    variables = {
      es_endpoint  = "${data.aws_elasticsearch_domain.this.endpoint}"
      index        = "${var.index}"
      delete_after = "${var.delete_after}"
      index_format = "${var.index_format}"
      sns_alert    = "${var.sns_alert}"
    }
  }

  tags = "${merge(
            var.tags,
            map("Scope", "${local.cluster_name}-lambda-function-to-elasticsearch"),
            )}"
}
