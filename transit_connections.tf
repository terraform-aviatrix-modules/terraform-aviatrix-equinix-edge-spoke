data "aviatrix_transit_gateway" "this" {
  for_each = var.transit_connections

  gw_name = each.key
}

locals {
  transit_connections = { for k, v in data.aviatrix_transit_gateway.this : k => merge(
    var.transit_connections[k],
    {
      cloud             = v.cloud_type
      customer_side_asn = var.customer_side_asn,
      equinix_metrocode = var.equinix_metrocode,
      notifications     = var.notifications,
      edge_uuids        = local.avx_edge_uuid,
      edge_interface    = index(keys(var.transit_connections), k) + 3
    }
  ) }
}

module "dx" {
  for_each = { for k, v in data.aviatrix_transit_gateway.this : k => v if v.cloud_type == 1 }

  base_circuit_name = var.transit_connections[k]["base_circuit_name"]
  transit_gateway_name = k
  speed             = var.transit_connections[k]["speed"]
  bgp_auth_key      = var.transit_connections[k]["bgp_auth_key"]
  vgw_asn           = var.transit_connections[k]["vgw_asn"]
  site_id           = local.site_id
  customer_side_asn = var.customer_side_asn
  equinix_metrocode = var.equinix_metrocode
  notifications     = var.notifications
  edge_uuids        = local.avx_edge_uuid
  edge_index        = index(keys(var.transit_connections, k)) + 3
}

module "exr" {
  for_each = { for k, v in data.aviatrix_transit_gateway.this : k => v if v.cloud_type == 8 }

  base_circuit_name = var.transit_connections[k]["base_circuit_name"]
  transit_gateway_name = k
  speed             = var.transit_connections[k]["speed"]
  bgp_auth_key      = var.transit_connections[k]["bgp_auth_key"]
  second_location   = var.transit_connections[k]["second_location"]
  site_id           = local.site_id
  customer_side_asn = var.customer_side_asn
  equinix_metrocode = var.equinix_metrocode
  notifications     = var.notifications
  edge_uuids        = concat([equinix_network_device.this.uuid], equinix_network_device.this.secondary_device[*].uuid)
  edge_index        = index(keys(var.transit_connections, k)) + 3
}