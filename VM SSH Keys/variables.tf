variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "environments" {
  description = "The environment for which resources are being created (e.g., dev, staging, prod)"
  type        = map(string)
  default = {
    "dev"  = "Standard_D2s_v3"
    "qa"   = "Standard_D2s_v3"
    "prod" = "Standard_D2s_v3"
  }
}
variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "devopsuser"
}

variable "ssh_public_key_path" {
  description = "The SSH public key for authentication"
  type        = string
  default     = "~/.ssh/azure_vm_key.pub" # ~/.ssh/azure_vm_key.pub
}
