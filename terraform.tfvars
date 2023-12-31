/*
resource_group     = "tf-assessment-rg"
location           = "South India"
vnetname           = "tf-assessment-vnet"
vnetaddress        = "192.168.0.0/16"
subnetnames        = ["subnet1", "subnet2"]
nics               = ["windows", "ubuntu"]
nsgname            = "tf-assessment-nsg"
storage_name       = "tfassessmentstorage001"
container_name     = "scripts"
blobs              = ["CustomScript_Nginx.sh", "CustomScript-iis.ps1"]
Keyvault           = "tf-assessment-kv"
kv-secret-name     = "vm-password"
kv-secret-password = ""
access-objectid    = "ea1da825-e327-4d64-88e7-f39808a7cb98"
lb-pip             = "tf-lb-pip-01"
lb-name            = "tf-assmnt-lb"
lb-fe              = "tf-assmnt-lb-fe"
bepool-nameprefix  = "tf-assmnt-lb-be"
lb-be              = "tf-assmnt-lb-be"
lb-hp              = "tf-assmnt-lb-hp"
lb-rule            = "tf-assmnt-rule"
*/