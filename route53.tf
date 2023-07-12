resource "aws_route53_record" "www" {
  for_each = var.environment
  zone_id  = data.aws_route53_zone.selected[each.key].zone_id
  name     = join(".", [each.value["dns_record"], each.value["zone_name"]])
  type     = "A"

  alias {
    name                   = data.aws_lb.dns_name[each.key].dns_name
    zone_id                = data.aws_elb_hosted_zone_id.main[each.key].id
    evaluate_target_health = true
  }
}