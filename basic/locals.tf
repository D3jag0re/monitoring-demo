locals {
  # Naming
  env = "test"
  loc = "world"

  # Deployment Parameters 
  subscription_id = "372372hryrhd2362placeholder"
  location        = "westus2"

  # Tags 
  technicalOwner = "me"
  businessOwner  = "you"

  # Networking 
  vnet_addressprefixes = ["172.17.0.0/16"]

  subnet_main_addressprefixes = ["172.17.2.0/24"]

  # File Paths 

  stress_file = "file"
  mon_file = "file"

}