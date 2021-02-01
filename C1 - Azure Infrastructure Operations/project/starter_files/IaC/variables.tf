variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "clientid" {}

variable "subscriptionid" {}

variable "clientsecret" {}

variable "tenantid" {}

variable "cust_scope" {
    default = "/subscriptions/"
}

variable "packerRG" {
    default = "packer-rg"
}

variable "packerImageName" {
  default = "UbuntuWebServer_Packer"
}

locals {
  common_tags = {
    Environment = "Production"
    CreatedBy = "Terraform"
  }
}