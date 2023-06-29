variable "environment" {}
variable "application" {}

module "beanstalk" {
  source = "./module"
  application = var.application
  environment = var.environment
}