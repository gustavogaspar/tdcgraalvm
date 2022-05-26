resource "oci_core_instance" "test_instance" {
    #Required
    availability_domain = "zPSG:SA-SAOPAULO-1-AD-1"
    compartment_id = var.compartment_id
    shape = "VM.StandardE3.Flex"
    display_name = "nginx"
    

    create_vnic_details {
        subnet_id = oci_core_subnet.test_subnet.id
    }
    
    metadata = {  
        "ssh_authorized_keys" : filebase64("./src/ssh-key-2021-06-09.key.pub"), 
        "user_data" : filebase64("./src/bootstrap.sh") 
        }
    
    shape_config {
        memory_in_gbs = "8"
        ocpus = "1"
    }

    source_details {
        #Required
        source_id = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaa47rnoig3plbksdrivvqz53l4xt6slyxzo62otgohfma3ligbllfa"
        source_type = "image"
        boot_volume_size_in_gbs = "50"
    }
    
    preserve_boot_volume = false
}