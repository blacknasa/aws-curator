provider "aws" {
  version          = "2.31.0"
}

provider "aws" {
  version    = "2.31.0"
  region     = "${var.vpn_vpc_region}"
  alias      = "vpn"
}

provider "template" {
  version    = "2.1.2"
}

terraform {
  backend "s3" {}
}
