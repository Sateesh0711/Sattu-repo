#Providers
variable "vsphere_user" {
  sensitive = true
}

variable "vsphere_password" {
  sensitive = true
}

variable "vsphere_server" {
  sensitive = true
}

#Infrastructure
variable "vsphere_datacenter" {
  description = "vSphere datacenter in which the virtual machine will be deployed"
}

variable "vsphere_compute_cluster" {
  description = "vSPhere cluster in which the virtual machine will be deployed"
}

variable "vsphere_datastore" {
  description = "Datastore in which the virtual machine will be deployed"
}

variable "vsphere_resource_pool" {
  description = "Resource pool in which the virtual machine will be deployed"
}

variable "vsphere_network" {
  description = "Portgroup to which the virtual machine will be connected"
}

#VM
variable "vm_template_name" {
  description = "VM template deployed from Rackspace Content Library"
}

variable "vm_guest_id" {
  description = "VM guest ID"
}

variable "vm_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine."
  default     = "1"
}

variable "vm_memory" {
  description = "The size of the virtual machine's memory in MB"
  default     = "1024"
}

variable "vm_ipv4_netmask" {
  description = "The IPv4 subnet mask"
}

variable "vm_ipv4_gateway" {
  description = "The IPv4 default gateway"
}

variable "vm_dns_servers" {
  description = "The list of DNS servers to configure on the virtual machine"
}

variable "vm_domain" {
  description = "Domain name of virtual machine"
}

variable "vm_firmware" {
  description = "Firmware of virtual machine, if templates is different from default"
}

variable "vsphere_guest_os_customization" {
   description = "VM Customization of virtual machine"
}


variable "vms" {
  description = "VM attributes that can be overriden"
  type = map(object({
    vm_vcpu   = optional(number)
    vm_memory = optional(number)
    vm_ip     = string
    vm_name   = string

  }))
  default = {}
}

variable "vm_disk_label" {
  description = "Disk label of the created virtual machine"
}

variable "vm_disk_size" {
  description = "Disk size of the created virtual machine in GB"
}

variable "vm_disk_thin" {
  description = "Disk type of the created virtual machine , thin or thick"
}

variable "script_text" {
  description = "The script text to run on the virtual machine."
  type        = string
  default     = ""
}
