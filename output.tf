output "management_ip" {
  value = local.management_prefix
}

output "ha_management_ip" {
  value = local.hagw_management_prefix
}

output "equinix_network_device" {
  value = equinix_network_device.default
}
