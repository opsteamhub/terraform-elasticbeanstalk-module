application = "node-app"

environment = {
  development = {
    setting = {
      MatcherHTTPCode = {  
        namespace = "aws:elasticbeanstalk:environment:process:default"
        name      = "MatcherHTTPCode"
        value     = "200"
      }  
      SystemType = {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name      = "SystemType"
        value     = "enhanced"
      }  
    }    

  },
  #production  = {
  #  setting = {}
  #}
}