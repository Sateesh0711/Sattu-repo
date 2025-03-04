#Data sources

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}


/*data "vsphere_content_library" "library" {
  name = var.vsphere_content_library
}

data "vsphere_content_library_item" "library_item" {
  name       = var.vm_template_name
  type       = "ovf"
  library_id = data.vsphere_content_library.library.id
}
*/

#Resource

resource "vsphere_virtual_machine" "vm" {
  for_each = var.vms

  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  guest_id         = var.vm_guest_id

  cdrom {
    client_device = true
   }

  network_interface {
        network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  name     = each.value.vm_name
  num_cpus = each.value.vm_vcpu
  memory   = each.value.vm_memory
  firmware		= var.vm_firmware 
  
  disk {

    # First disk (default unit_number 0)

    label = "primary_disk"

    size = 300

  }

  disk {

    # Second disk with a unique unit_number

    label = "secondary_disk"

    size = 200

    unit_number = 1

  }

clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    
        customize {
      linux_options {
        host_name   = each.value.vm_name
        domain      = var.vm_domain
        script_text = var.script_text
        time_zone = "US/Central" 
      
      }
      network_interface {
        ipv4_address    = each.value.vm_ip
        ipv4_netmask    = var.vm_ipv4_netmask
        dns_server_list = var.vm_dns_servers
      }

      ipv4_gateway = var.vm_ipv4_gateway    
    }
    

    #customization_spec {
    # id = each.data.vsphere_guest_os_customization.linux.id
    # }

  }
}


