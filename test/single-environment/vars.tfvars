application = "app-test"
vpc_id = "vpc-xxxxx"
public_subnets = ["subnet-xxxxxx", "subnet-xxxxxx"]
elb_scheme = "internet facing"
associace_public_ip = "True"

environment = {
  development = {
    zone_name = "development.example.com"
    dns_record = "app-test"    
    setting = {
      SSLCertificateId = {
        namespace = "aws:elbv2:listener:443"
        name = "SSLCertificateArns"
        value = "arn:aws:acm:us-east-1:xxxxxxx:certificate/xxxxxxxxxxxx"
      }      
    }    

  },
  #production  = {
  #  setting = {}
  #}
}