resource "random_integer" "wan_cidr" {
  min = 0
  max = 8191
}

resource "aviatrix_edge_spoke" "this" {
  for_each = local.gateways

  # mandatory
  gw_name                        = each.value["name"]
  site_id                        = local.site_id
  management_interface_config    = "Static"
  management_interface_ip_prefix = "192.168.10.101/24" #This is placeholder and will be updated by cloud-init.
  management_default_gateway_ip  = "192.168.10.254"    #This is placeholder and will be updated by cloud-init.
  wan_interface_ip_prefix        = each.value["wan_ip_prefix"]
  wan_default_gateway_ip         = local.wan_default
  lan_interface_ip_prefix        = each.value["lan_ip_prefix"]
  dns_server_ip                  = var.dns_server_ips[0]
  secondary_dns_server_ip        = var.dns_server_ips[1]
  ztp_file_type                  = "cloud-init"
  ztp_file_download_path         = "."
  local_as_number                = var.customer_side_asn

  # advanced options - optional

  #   prepend_as_path                  = var.prepend_as_path
  #   enable_learned_cidrs_approval    = var.enable_learned_cidrs_approval
  #   approved_learned_cidrs           = var.approved_learned_cidrs
  #   spoke_bgp_manual_advertise_cidrs = var.spoke_bgp_manual_advertise_cidrs
  #   enable_preserve_as_path          = var.enable_preserve_as_path
  #   bgp_polling_time                 = var.bgp_polling_time
  #   bgp_hold_time                    = var.bgp_hold_time
  #   enable_edge_transitive_routing   = var.enable_edge_transitive_routing
  #   enable_jumbo_frame               = var.enable_jumbo_frame
  #   latitude                         = var.latitude
  #   longitude                        = var.longitude

  lifecycle {
    ignore_changes = [
      management_egress_ip_prefix,
      management_default_gateway_ip
    ]
  }
}

data "local_file" "this" {
  for_each = aviatrix_edge_spoke.this

  filename = "./${each.value.gw_name}-${local.site_id}-cloud-init.txt"
}

data "equinix_network_account" "this" {
  metro_code = var.metro_code
}

resource "equinix_network_file" "this" {
  for_each = data.local_file.this

  metro_code       = data.equinix_network_account.this.metro_code
  byol             = true
  self_managed     = true
  device_type_code = var.type_code
  process_type     = "CLOUD_INIT"
  file_name        = split("/", each.value.filename)[1]
  content          = each.value.content

  lifecycle {
    ignore_changes = all
  }
}

resource "equinix_network_device" "this" {
  metro_code         = data.equinix_network_account.this.metro_code
  account_number     = data.equinix_network_account.this.number
  type_code          = var.type_code
  byol               = true
  self_managed       = true
  core_count         = var.core_count
  package_code       = var.package_code
  version            = var.device_version
  name               = local.gateways["primary"]["name"]
  notifications      = var.notifications
  term_length        = var.term_length
  cloud_init_file_id = equinix_network_file.this["primary"].uuid
  acl_template_id    = equinix_network_acl_template.this.id

  dynamic "secondary_device" {
    for_each = lookup(local.gateways, "secondary", null) != null ? [1] : []
    content {
      name               = local.gateways["secondary"]["name"]
      metro_code         = data.equinix_network_account.this.metro_code
      account_number     = data.equinix_network_account.this.number
      notifications      = var.notifications
      cloud_init_file_id = equinix_network_file.this["secondary"].uuid
      acl_template_id    = equinix_network_acl_template.this.id
    }
  }
}