module "instance" {
  source  = "oracle-terraform-modules/compute-instance/oci"
  version = "2.4.1"

  # Pass all variables to the module
  compartment_ocid            = var.compartment_ocid
  instance_timeout            = var.instance_timeout
  freeform_tags               = var.freeform_tags
  defined_tags                = var.defined_tags
  ad_number                   = var.ad_number
  instance_count              = var.instance_count
  instance_display_name       = var.instance_display_name
  instance_flex_memory_in_gbs = var.instance_flex_memory_in_gbs
  instance_flex_ocpus         = var.instance_flex_ocpus
  instance_state              = var.instance_state
  shape                       = var.shape
  cloud_agent_plugins         = var.cloud_agent_plugins
  baseline_ocpu_utilization   = var.baseline_ocpu_utilization
  source_ocid                 = var.source_ocid
  source_type                 = var.source_type
  extended_metadata           = var.extended_metadata
  resource_platform           = var.resource_platform
  ssh_authorized_keys         = var.ssh_authorized_keys
  ssh_public_keys             = var.ssh_public_keys
  user_data                   = var.user_data
  assign_public_ip            = var.assign_public_ip
  hostname_label              = var.hostname_label
  ipxe_script                 = var.ipxe_script
  private_ips                 = var.private_ips
  public_ip                   = var.public_ip
  public_ip_display_name      = var.public_ip_display_name
  skip_source_dest_check      = var.skip_source_dest_check
  subnet_ocids                = var.subnet_ocids
  vnic_name                   = var.vnic_name
  primary_vnic_nsg_ids        = var.primary_vnic_nsg_ids
  attachment_type             = var.attachment_type
  block_storage_sizes_in_gbs  = var.block_storage_sizes_in_gbs
  boot_volume_backup_policy   = var.boot_volume_backup_policy
  boot_volume_size_in_gbs     = var.boot_volume_size_in_gbs
  preserve_boot_volume        = var.preserve_boot_volume
  use_chap                    = var.use_chap

  providers = {
    oci = oci.home
  }
}
