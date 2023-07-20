variable "application" {
  description = "Application Name"
  type        = string
}

variable "provisioned" {
  description = "Provisioning By Terraform"
  type        = string
  default     = "Terraform"
}

variable "owner" {
  description = "Project Owner"
  type        = string
  default     = "OpsTeam"
}

variable "environment" {
  description = "Custom Parameters for environment"
  type = map(object({
    solution_stack_name = optional(string, "64bit Amazon Linux 2 v3.5.9 running Docker")
    tier                = optional(string, "WebServer")
    instance_type       = optional(string, "t2.micro")
    zone_name           = optional(string, "teste.com.")
    dns_record          = optional(string, "app.teste.com")
    min_size            = optional(number, 1)
    max_size            = optional(number, 2)
    elb_scheme          = optional(string, "internet-facing")
    cert_domain         = optional(string, "*.example.com")
    vpc_id              = optional(string, "")
    public_subnets      = optional(list(string), [""])
    loadbalancer_type   = optional(string, "application")
    associace_public_ip = optional(string, "False")
    retentionlogsdays   = optional(string, "1")
    streamlogs          = optional(string, "false")
    deleteonterminate   = optional(string, "true")
    private_zone        = optional(bool, false)
    app_port            = optional(string, "80")
    healthcheck_path    = optional(string, "/")
    http_status_code    = optional(string, "200")
    setting = map(object({
      namespace = optional(string, "aws:autoscaling:launchconfiguration")
      name      = optional(string, "IamInstanceProfile")
      value     = optional(string, "aws-elasticbeanstalk-ec2-role")
    }))
  }))
  default = {}
}
