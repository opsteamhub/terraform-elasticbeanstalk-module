application = "app-test"

environment = {
  development = {
    zone_name           = "development.example.com"
    dns_record          = "app-test"
    cert_domain         = "*.example.com"
    vpc_id              = "vpc-xxxxx"
    public_subnets      = ["subnet-xxxxxx", "subnet-xxxxxx"]
    elb_scheme          = "internet facing"
    associace_public_ip = "True"
    setting             = {}
  }
}