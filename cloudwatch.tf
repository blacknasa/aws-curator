resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${local.cluster_name}-es-cleanup-execution-schedule"
  description         = "${local.cluster_name}-es-cleanup-execution-schedule"
  schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "es_cleanup" {
  count     = "${length(data.aws_subnet_ids.this.ids) == 0 ? 1 : 0}"
  target_id = "${local.cluster_name}-lambda-es-cleanup"
  rule      = "${aws_cloudwatch_event_rule.schedule.name}"
  arn       = "${aws_lambda_function.es_cleanup.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = "${length(data.aws_subnet_ids.this.ids) == 0 ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.es_cleanup.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.schedule.arn}"
}

resource "aws_cloudwatch_event_target" "es_cleanup_vpc" {
  count     = "${length(data.aws_subnet_ids.this.ids) > 0 ? 1 : 0}"
  target_id = "${local.cluster_name}-lambda-es-cleanup"
  rule      = "${aws_cloudwatch_event_rule.schedule.name}"
  arn       = "${aws_lambda_function.es_cleanup_vpc.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_vpc" {
  count         = "${length(data.aws_subnet_ids.this.ids) > 0 ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.es_cleanup_vpc.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.schedule.arn}"
}
