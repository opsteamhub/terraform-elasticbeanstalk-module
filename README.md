## Terraform Elasticbeanstalk Module
Provisioning application and environments.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elastic_beanstalk_application.elasticapp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application) | resource |
| [aws_elastic_beanstalk_environment.beanstalkappenv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) | resource |
| [aws_lb_listener_rule.redirect_http_to_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_route53_record.www](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_elb_hosted_zone_id.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_hosted_zone_id) | data source |
| [aws_lb.dns_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb_listener.http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application Name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Custom Parameters for environment | <pre>map(object({<br>    solution_stack_name = optional(string, "64bit Amazon Linux 2 v3.5.9 running Docker")<br>    tier                = optional(string, "WebServer")<br>    instance_type       = optional(string, "t2.micro")<br>    zone_name           = optional(string, "teste.com.")<br>    dns_record          = optional(string, "app.teste.com")<br>    min_size            = optional(number, 1)<br>    max_size            = optional(number, 2)<br>    elb_scheme          = optional(string, "internet-facing")<br>    cert_domain         = optional(string, "*.example.com")<br>    vpc_id              = optional(string, "")<br>    public_subnets      = optional(list(string), [""])<br>    loadbalancer_type   = optional(string, "application")<br>    associace_public_ip = optional(string, "False")<br>    solution_stack_name = optional(string, "64bit Amazon Linux 2 v3.5.9 running Docker")<br>    setting = map(object({<br>      namespace = optional(string, "aws:autoscaling:launchconfiguration")<br>      name      = optional(string, "IamInstanceProfile")<br>      value     = optional(string, "aws-elasticbeanstalk-ec2-role")<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Project Owner | `string` | `"OpsTeam"` | no |
| <a name="input_provisioned"></a> [provisioned](#input\_provisioned) | Provisioning By Terraform | `string` | `"Terraform"` | no |

## Outputs

No outputs.
