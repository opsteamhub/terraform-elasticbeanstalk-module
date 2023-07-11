variable "environment" {}
variable "application" {}
variable "vpc_id" {}
variable "public_subnets" {}
variable "elb_scheme" {}
variable "associace_public_ip" {}

module "beanstalk" {
  source = "./"
  application = var.application
  environment = var.environment
  vpc_id = var.vpc_id
  public_subnets = var.public_subnets
  elb_scheme = var.elb_scheme 
  associace_public_ip = var.associace_public_ip
}