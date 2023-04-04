resource "aviatrix_edge_spoke_transit_attachment" "edge_attachment" {
  for_each = local.transit_connections

  spoke_gw_name   = aviatrix_edge_spoke.this[primary].gw_name
  transit_gw_name = each.key

  number_of_retries = 3
}

resource "aviatrix_edge_spoke_transit_attachment" "edge_ha_attachment" {
  for_each = { for k, v in local.transit_connections : k => v if var.redundant }

  spoke_gw_name   = aviatrix_edge_spoke.this[secondary].gw_name
  transit_gw_name = each.key

  number_of_retries = 3
}