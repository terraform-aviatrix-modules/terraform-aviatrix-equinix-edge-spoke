locals {

  additional_wan_interfaces      = {}
  hagw_additional_wan_interfaces = {}

  #Grab cloud init from file and decode it
  original_cloud_init = yamldecode(data.local_file.cloud_init_content.content)

  #take write_files content section from original cloud init and decode it
  write_files_orig = jsondecode(local.original_cloud_init.write_files[0].content)

  controller_ip = local.write_files_orig.controller_ip


  management_prefix      = format("%s/32", equinix_network_device.default.ssh_ip_address)
  hagw_management_prefix = var.ha_gw ? format("%s/32", equinix_network_device.default.secondary_device[0].ssh_ip_address) : null

  #   primary = {
  #     name          = var.gw_name,
  #     wan_ip_prefix = "${cidrhost(local.wan_prefix, 2)}/${local.wan_prefixlen}",
  #     lan_ip_prefix = "${cidrhost(var.lan_interface_ip_prefix, 2)}/${local.lan_prefixlen}"
  #   }

  #   secondary = {
  #     name          = "${var.gw_name}-ha",
  #     wan_ip_prefix = "${cidrhost(local.wan_prefix, 3)}/${local.wan_prefixlen}"
  #     lan_ip_prefix = "${cidrhost(var.lan_interface_ip_prefix, 3)}/${local.lan_prefixlen}"
  #   }

  #   gateways = var.redundant ? merge(local.primary, local.secondary) : local.primary

  #   # Entire section could go away with 7.1 or at least need new logic.
  #   wan_prefix    = var.wan_interface_ip_prefix == null ? cidrsubnet("169.254.0.0/16", 13, random_integer.wan_cidr.result) : var.wan_interface_ip_prefix
  #   wan_prefixlen = split("/", local.wan_prefix)[1]
  #   wan_default   = cidrhost(local.wan_prefix, 1)

  #   lan_prefixlen = split("/", var.lan_interface_ip_prefix)[1]

  #   site_id         = coalesce(var.site_id, "equinix-${var.equinix_metrocode}")
  #   acl_name        = "${var.gw_name}-acl"
  #   acl_description = "ACL for ${var.gw_name}, primary and ha (if deployed.)"
}
