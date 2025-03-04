#Infrastructure
vsphere_datacenter      = "DFW3-802724-01"
vsphere_compute_cluster = "DFW3-802724-01-Cluster-01"
vsphere_datastore       = "1356360-dsan-fc-hlu1-Powerstore"
vsphere_resource_pool   = "Compute-ResourcePool"
vsphere_network         = "dfw-mgmt-01"
#vsphere_content_library = "RXT-SDDC"

#VM
vm_template_name = "DFW-Oracle-Linux9-MySQL-tmpl"
vsphere_guest_os_customization = "Rfxcel - Oracle Linux - New Deploy"
vm_guest_id      = "oracleLinux9_64Guest"
vm_vcpu          = "8"
vm_memory        = "24576"
vm_ipv4_netmask  = "24"
vm_ipv4_gateway  = "172.29.0.1"
vm_dns_servers   = ["72.3.128.240", "72.3.128.241"]
vm_disk_label    = "disk0"
vm_disk_size     = "300"
vm_disk_thin     = "true"
vm_domain        = "example.com"
vm_firmware      = "bios"
script_text = <<-EOT
#!/bin/bash

log_path="/var/log/cust_output.log"
phase="precustomization" # hardcoded for testing purposes

if [[ "x$1" = "xprecustomization" ]]; then
  echo "Adding rackuser account..." >> /var/log/cust_output.log
  useradd -m -U -s /bin/bash rackuser
  echo "rackuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/98-rackuser
  mkdir -p /home/rackuser/.ssh >> /var/log/cust_output.log
  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEiwYfYkKnhWN29iX7fW6Zyb3UeRLZU7TodHmW4lhjFj eddsa-key-20230316" > /home/rackuser/.ssh/authorized_keys
  chown -R rackuser:rackuser /home/rackuser/.ssh >> /var/log/cust_output.log
  chmod 700 /home/rackuser/.ssh >> /var/log/cust_output.log
  chmod 600 /home/rackuser/.ssh/authorized_keys >> /var/log/cust_output.log
  password=u!3FM4FhtoJ
  echo "root:$password" | chpasswd
  vmtoolsd --cmd "info-set guestinfo.custom.password $password"
elif [[ "x$1" = "xpostcustomization" ]]; then
  echo "customization complete..." >> /var/log/cust_output.log
fi
EOT

vms = {
  rhel1 = {
    vm_name = "dfw-p-w-maj-all-01"
    vm_ip   = "172.29.0.11"
     
  },


  rhel2 = {
    vm_name = "dfw-p-w-maj-all-02"
    vm_ip   = "172.29.0.12"
    
  }

}
