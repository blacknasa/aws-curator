variable "aws_region" {
    default = ""
}

variable "vpn_vpc_region" {
  default = ""
}

variable "vpn_vpc_tag_value" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "aws_profile" {
    default = ""
}

variable "child_domain_name" {
  default     = ""
}

variable "prefix" {
  description = "A prefix for the resource names, this helps create multiple instances of this stack for different environments"
  default = ""
}

variable "schedule" {
  description = "Cron Schedule expression for running the cleanup function"
  default = "cron(0 3 * * ? *)"
}

variable "sns_alert" {
  description = "SNS ARN to publish any alert"
  default     = ""
}

variable "es_endpoint" {
  description = "AWS ES fqdn"
  default = ""
}

variable "index" {
  description = "Index/indices to process comma separated, with all every index will be processed except '.kibana'"
  default     = "all"
}

variable "delete_after" {
  description = "Numbers of days to preserve logs"
  default     = 15
}

variable "index_format" {
  description = "Combined with 'index' variable is used to evaluate the index age"
  default     = "%Y.%m.%d"
}

variable "python_version" {
  description = "Python version to be used"
  default = "2.7"
}

variable "subnet_ids" {
  description = "Subnet IDs you want to deploy the lambda in. Only fill this in if you want to deploy your Lambda function inside a VPC."
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  default = {
    Name = "es-cleanup"
  }
}
