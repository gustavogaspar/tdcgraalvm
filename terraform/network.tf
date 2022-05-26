resource "oci_core_vcn" "test_vcn" {
    #Required
    compartment_id = var.compartment_id
    cidr_blocks = ["10.0.0.0/16"]
    display_name = "vcn-tf"
}

resource "oci_core_subnet" "test_subnet" {
    #Required
    cidr_block = "10.0.1.0/24"
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.test_vcn.id
}



