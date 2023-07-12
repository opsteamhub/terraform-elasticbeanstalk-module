data "aws_route53_zone" "selected" {
  for_each     = var.environment
  name         = each.value["zone_name"]
  private_zone = each.value["private_zone"]
}

data "aws_lb" "dns_name" {
  for_each = var.environment
  arn      = one(aws_elastic_beanstalk_environment.beanstalkappenv[each.key].load_balancers)
}

data "aws_elb_hosted_zone_id" "main" {
  for_each = var.environment
}

data "aws_acm_certificate" "issued" {
  for_each    = var.environment
  domain      = each.value["cert_domain"]
  statuses    = ["ISSUED"]
  most_recent = true
}