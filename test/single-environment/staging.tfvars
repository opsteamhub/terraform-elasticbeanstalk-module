application = "app-test"

environment = {
  development = {
    vpc_id              = "vpc-0bf5dc0c2e6d142d3"
    public_subnets      = ["subnet-0578bc27ff2728d3c", "subnet-0585fb33ccf1ef432"]
    elb_scheme          = "internet facing"
    associace_public_ip = "True"
    zone_name           = "staging.beerorcoffee.com"
    dns_record          = "app-test"
    cert_domain         = "*.woba.com.br"
    setting             = {}
  }
  #production  = {
  #  setting = {}
  #}
}