output "aviatrix_edge_spoke" {
  value = aviatrix_edge_spoke.this
}

output "equinix_network_device" {
  value = equinix_network_device.this
}

output "transit_connections" {
  value = merge(
    try(module.dx, {}),
    try(module.exr, {})
  )
}