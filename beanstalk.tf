resource "aws_elastic_beanstalk_application" "elasticapp" {
  name = var.application
}

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  for_each            = var.environment
  name                = join("-", [var.application, each.key])
  application         = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name = can(each.value["solution_stack_name"]) ? each.value["solution_stack_name"] : each.value["solution_stack_name"]
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
    value     = aws_iam_role.ec2_role[each.key].name
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
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = data.aws_acm_certificate.issued[each.key].arn
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
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = each.value["streamlogs"]
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = each.value["retentionlogsdays"]
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = each.value["deleteonterminate"]
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = each.value["app_port"]
  }  
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = each.value["healthcheck_path"]
  }  
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = each.value["http_status_code"]
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




