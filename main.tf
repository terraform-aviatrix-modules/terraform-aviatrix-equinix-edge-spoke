resource "aviatrix_edge_equinix" "default" {
  account_name = var.account

  gw_name                = var.name
  site_id                = var.site_id
  ztp_file_download_path = "./"

  interfaces {
    name          = "eth0"
    type          = "WAN"
    ip_address    = var.wan1_ip
    gateway_ip    = var.wan1_gateway_ip
    wan_public_ip = var.wan1_public_ip
  }

  interfaces {
    name       = "eth1"
    type       = "LAN"
    ip_address = var.lan_ip
  }

  dynamic "interfaces" {
    for_each = local.additional_wan_interfaces

    content {
      name       = interfaces.key
      type       = "WAN"
      ip_address = interfaces.value.ip
      gateway_ip = interfaces.value.gateway
    }
  }

  lifecycle {
    ignore_changes = [
      management_egress_ip_prefix_list,
      interfaces
    ]
  }
}

resource "aviatrix_edge_equinix_ha" "default" {
  count                  = var.ha_gw ? 1 : 0
  primary_gw_name        = aviatrix_edge_equinix.default.gw_name
  ztp_file_download_path = "./"

  interfaces {
    name          = "eth0"
    type          = "WAN"
    ip_address    = var.ha_wan1_ip
    gateway_ip    = var.ha_wan1_gateway_ip
    wan_public_ip = var.ha_wan1_public_ip
  }

  interfaces {
    name       = "eth1"
    type       = "LAN"
    ip_address = var.ha_lan_ip
  }

  dynamic "interfaces" {
    for_each = local.hagw_additional_wan_interfaces

    content {
      name       = interfaces.key
      type       = "WAN"
      ip_address = interfaces.value.ip
      gateway_ip = interfaces.value.gateway
    }
  }

  lifecycle {
    ignore_changes = [
      management_egress_ip_prefix_list,
      interfaces
    ]
  }
}

data "local_file" "cloud_init_content" {
  filename = format("./%s-%s-cloud-init.txt", aviatrix_edge_equinix.default.id, aviatrix_edge_equinix.default.site_id)

  depends_on = [aviatrix_edge_equinix.default]
}

data "local_file" "hagw_cloud_init_content" {
  count    = var.ha_gw ? 1 : 0
  filename = format("./%s-cloud-init.txt", aviatrix_edge_equinix_ha.default[0].id)

  depends_on = [aviatrix_edge_equinix_ha.default]
}

resource "equinix_network_file" "default" {
  metro_code       = var.equinix_metro_code
  byol             = true
  self_managed     = true
  device_type_code = "AVIATRIX_EDGE"
  process_type     = "CLOUD_INIT"
  file_name        = data.local_file.cloud_init_content.filename
  content          = data.local_file.cloud_init_content.content

  lifecycle {
    ignore_changes = all
  }
}

resource "equinix_network_file" "ha_gw" {
  count            = var.ha_gw ? 1 : 0
  metro_code       = var.equinix_metro_code
  byol             = true
  self_managed     = true
  device_type_code = "AVIATRIX_EDGE"
  process_type     = "CLOUD_INIT"
  file_name        = data.local_file.hagw_cloud_init_content[0].filename
  content          = data.local_file.hagw_cloud_init_content[0].content

  lifecycle {
    ignore_changes = all
  }
}

resource "equinix_network_device" "default" {
  metro_code         = var.equinix_metro_code
  account_number     = var.equinix_account_id
  type_code          = "AVIATRIX_EDGE_10"
  byol               = true
  self_managed       = true
  core_count         = var.core_count
  package_code       = "STD"
  version            = var.device_version
  name               = aviatrix_edge_equinix.default.id
  notifications      = var.notifications
  term_length        = var.term_length
  cloud_init_file_id = equinix_network_file.default.uuid
  acl_template_id    = equinix_network_acl_template.default.id

  dynamic "secondary_device" {
    for_each = var.ha_gw ? ["dummy"] : [] #Empty list (false) skips this section
    content {
      name               = aviatrix_edge_equinix_ha.default[0].id
      metro_code         = var.equinix_metro_code
      account_number     = var.equinix_account_id
      notifications      = var.notifications
      cloud_init_file_id = equinix_network_file.ha_gw[0].uuid
      acl_template_id    = equinix_network_acl_template.default.id
    }
  }
}

data "aviatrix_caller_identity" "self" {}

#Set mgmt egress CIDR
resource "terracurl_request" "update_edge_gateway" {
  name            = "update_edge_gateway"
  method          = "POST"
  url             = "https://${local.controller_ip}/v2/api"
  skip_tls_verify = true
  max_retry       = 3
  retry_interval  = 3

  headers = {
    "Content-Type" = "application/json"
  }

  request_body = jsonencode({
    action         = "update_edge_gateway"
    CID            = data.aviatrix_caller_identity.self.cid
    name           = aviatrix_edge_equinix.default.id
    mgmt_egress_ip = local.management_prefix
  })

  response_codes = [200]

  lifecycle {
    ignore_changes = all
  }
}

resource "terracurl_request" "update_ha_edge_gateway" {
  count           = var.ha_gw ? 1 : 0
  name            = "hagw_update_edge_gateway"
  method          = "POST"
  url             = "https://${local.controller_ip}/v2/api"
  skip_tls_verify = true
  max_retry       = 3
  retry_interval  = 3

  headers = {
    "Content-Type" = "application/json"
  }

  request_body = jsonencode({
    action         = "update_edge_gateway"
    CID            = data.aviatrix_caller_identity.self.cid
    name           = aviatrix_edge_equinix_ha.default[0].id
    mgmt_egress_ip = local.hagw_management_prefix
  })

  response_codes = [200]

  lifecycle {
    ignore_changes = all
  }
}

resource "equinix_network_acl_template" "default" {
  name        = "Equinix-avx-acl"
  description = "AVX Equinix ACL"
  inbound_rule {
    subnet      = format("%s/32", local.controller_ip)
    protocol    = "TCP"
    src_port    = "any"
    dst_port    = "any"
    description = "Controller IP"
  }
  inbound_rule {
    subnet      = "8.8.8.8/32"
    protocol    = "UDP"
    src_port    = "any"
    dst_port    = "any"
    description = "DNS IP"
  }
  inbound_rule {
    subnet      = "8.8.4.4/32"
    protocol    = "UDP"
    src_port    = "any"
    dst_port    = "any"
    description = "DNS IP 2"
  }
  inbound_rule {
    subnet      = "169.254.0.0/30"
    protocol    = "IP"
    src_port    = "any"
    dst_port    = "any"
    description = "dx aws router"
  }
  inbound_rule {
    subnet      = "10.254.200.0/30"
    protocol    = "IP"
    src_port    = "any"
    dst_port    = "any"
    description = "dx aws router"
  }
  inbound_rule {
    subnet      = "10.0.0.0/8"
    protocol    = "IP"
    src_port    = "any"
    dst_port    = "any"
    description = "private network"
  }
}
