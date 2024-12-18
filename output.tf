output "management_ip" {
  value = local.management_prefix
}

output "ha_management_ip" {
  value = local.hagw_management_prefix
}

output "equinix_network_device" {
  value = equinix_network_device.default
}

output "aviatrix_edge_equinix" {
  value = aviatrix_edge_equinix.default
}

output "aviatrix_edge_equinix_ha" {
  value = var.ha_gw ? aviatrix_edge_equinix_ha.default : null
}
