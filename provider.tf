provider "aws" {
  default_tags {
    tags = {
      owner         = var.owner
      application   = var.application
      provisionedBy = var.provisioned
    }
  }
}