resource "vsphere_virtual_machine" "copper" {
  name             		= "copper"
  annotation			= "Plex Server"
  resource_pool_id 		= data.vsphere_resource_pool.resource_pool.id
  datastore_id     		= data.vsphere_datastore.datastore.id
  num_cpus 				= "4"
  memory   				= "8192"
  memory_reservation	= "8192"
  folder				= vsphere_folder.appfolder.path
  guest_id 				= data.vsphere_virtual_machine.large.guest_id
  scsi_type 			= data.vsphere_virtual_machine.large.scsi_type

  network_interface {
    network_id   		= data.vsphere_network.ProdNetwork.id
    adapter_type 		= "vmxnet3"
    use_static_mac 		= true
    mac_address			= "00:50:56:a9:8b:90"
  }

   network_interface {
    network_id   		= data.vsphere_network.SAN.id
    adapter_type 		= "vmxnet3"
    use_static_mac 		= true
    mac_address			= "00:50:56:a9:c6:06"
  }

  disk {
    label            	= "disk0"
    size             	= data.vsphere_virtual_machine.large.disks.0.size
    eagerly_scrub    	= data.vsphere_virtual_machine.large.disks.0.eagerly_scrub
    thin_provisioned 	= data.vsphere_virtual_machine.large.disks.0.thin_provisioned
  }

  clone {
    template_uuid 		= data.vsphere_virtual_machine.large.id

    customize {
      linux_options {
        host_name 		= "copper"
        domain    		= "khaosx.net"
        hw_clock_utc 	= true
        time_zone		= "America/New_York"
      }

      network_interface {
        ipv4_address 	= "192.168.10.37"
        ipv4_netmask 	= "24"
      }
     
      network_interface {
        ipv4_address 	= "192.168.15.37"
        ipv4_netmask 	= "24"
      }

      ipv4_gateway    	= "192.168.10.1"
      dns_server_list 	= [ "192.168.10.11", "192.168.10.10" ]
      dns_suffix_list 	= [ "khaosx.net" ]
    }
  }
}