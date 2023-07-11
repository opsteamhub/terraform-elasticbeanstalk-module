variable "environment" {}
variable "application" {}

module "beanstalk" {
  source      = "../../"
  application = var.application
  environment = var.environment
}