variable "resource_group" {
  type        = string
  description = "resource group name"
}

variable "location" {
  type        = string
  description = "resource location"
}

variable "vnetname" {
  type        = string
  description = "vnet name"
}

variable "vnetaddress" {
  type        = string
  description = "vnet address prefix"
}

variable "subnetnames" {
  type        = set(string)
  description = "subnet names"
}

variable "nics" {
  type        = list(string)
  description = "nic cards for VM"
}

variable "nsgname" {
  type        = string
  description = "NSG Name"
}

variable "storage_name" {
  type        = string
  description = "Storage account name"
}

variable "container_name" {
  type        = string
  description = "Container name"
}

variable "blobs" {
  type        = list(string)
  description = "files to be uploaded in blob"
}

variable "Keyvault" {
  type        = string
  description = "keyvault name"

}

variable "kv-secret-name" {
  type        = string
  description = "name of the key vault sectret to store the VM password"
}

variable "kv-secret-password" {
  type        = string
  description = "password to store key vault sectret"
}

variable "access-objectid" {
  type        = string
  description = "object id of the ad user for KV access"
}

variable "lb-pip" {
  type        = string
  description = "name of the Public ip of load balancer"
}

variable "lb-name" {
  type        = string
  description = "load balancer name"
}

variable "lb-fe" {
  type        = string
  description = "load balancer front-end name"
}

variable "lb-be" {
  type        = string
  description = "load balancer backend-end name"
}

variable "bepool-nameprefix" {
  type        = string
  description = "load balancer backend-end pool name"
}

variable "lb-hp" {
  type        = string
  description = "load balancer health probe name"
}

variable "lb-rule" {
  type        = string
  description = "load balancer health probe name"
}