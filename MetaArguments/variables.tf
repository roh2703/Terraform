variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_D2s_v3"
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

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}