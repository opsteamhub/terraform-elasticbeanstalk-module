variable "application" {
  default = "defaultapp"
}

variable "vpc_id" {
  default = "vpc-0bf5dc0c2e6d142d3"
}
variable "public_subnets" {
  default = ["subnet-0c2165102d144abb6", "subnet-0b162980672edcebb"]
}

variable "owner" {
  default = "OpsTeam"
}

variable "project" {
  default = "beanstalk"
}

variable "environment" {
  type = map(object({
    solution_stack_name = optional(string, "64bit Amazon Linux 2 v5.8.2 running Node.js 18")
    tier                = optional(string, "WebServer")
  }))
  default = {}
}