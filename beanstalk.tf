#data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
#  for_each            = var.environment
#  most_recent = true
#
#  name_regex = "^64bit Amazon Linux (.*) running Docker"
#  #name_regex = "64bit Amazon Linux 2 v3.5.9 running Docker"
#
#}

#data "aws_elastic_beanstalk_solution_stack" "docker" {
#  for_each            = var.environment
#  most_recent = true
#  name_regex = "^64bit Amazon Linux (.*) running Docker"
#}


# Create elastic beanstalk application

resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.application
}

# Create elastic beanstalk Environment

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  for_each            = var.environment
  name                = join("-", [var.application, each.key])
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = can(each.value["solution_stack_name"]) ? each.value["solution_stack_name"] : var.solution_stack_name
  tier                = each.value["tier"]

  dynamic "setting" {
    for_each = each.value["setting"]
    content {
      namespace = setting.value["namespace"]
      name      = setting.value["name"]
      value     = setting.value["value"]
    }
  }


  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = each.value["vpc_id"]
  }

  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "True"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = each.value["associace_public_ip"]
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", each.value["public_subnets"])
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = each.value["loadbalancer_type"]
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = each.value["instance_type"]
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = each.value["elb_scheme"]
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = each.value["min_size"]
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = each.value["max_size"]
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

}


data "aws_lb_listener" "http_listener" {
  for_each          = var.environment
  load_balancer_arn = one(aws_elastic_beanstalk_environment.beanstalkappenv[each.key].load_balancers)
  port              = 80
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  for_each     = var.environment
  listener_arn = data.aws_lb_listener.http_listener[each.key].arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

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

data "aws_route53_zone" "selected" {
  for_each     = var.environment
  name         = each.value["zone_name"]
  private_zone = false
}

data "aws_lb" "dns_name" {
  for_each = var.environment
  arn      = one(aws_elastic_beanstalk_environment.beanstalkappenv[each.key].load_balancers)
}

data "aws_elb_hosted_zone_id" "main" {
  for_each = var.environment
}