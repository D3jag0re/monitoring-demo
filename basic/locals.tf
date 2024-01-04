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

  # Database (WARNING: SENSITIVE INFORMATION SEE NOTES SECTION IN README FOR EXPLANATION)

  sql_server_login_name = "test@user.com"
  sql_server_password   = "NotaRealPassword"
  aad_login_username    = "test@user.com"
  object_id             = "8411414c-728e-11ee-b962-0242ac120002" #notaRealUUID

}