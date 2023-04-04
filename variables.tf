variable "gw_name" {
  description = "Name of the Aviatrix Edge gateway to deploy."
  type        = string
}

variable "site_id" {
  description = "Site ID in Aviatrix Controller. Default: Equinix-<metrocode>."
  default     = ""
  type        = string
}

variable "redundant" {
  description = "Deploy redundant Aviatrix Edge Gateways."
  default     = true
  type        = bool
}

variable "wan_interface_ip_prefix" {
  description = "CIDR range to use on the WAN interface of the Aviatrix Edge VM. Default: Random /29 CIDR in 169.254 range."
  default     = null
  type        = string
}

variable "lan_interface_ip_prefix" {
  description = "CIDR range to use on the LAN interface of the Aviatrix Edge VM."
  type        = string
}

variable "dns_server_ips" {
  description = "List of exactly 2 DNS server IPs. Default: 8.8.8.8, 1.1.1.1"
  default     = ["8.8.8.8", "1.1.1.1"]
  type        = list(string)

  validation {
    condition     = length(var.dns_server_ips) == 2
    error_message = "Supply 2 DNS server IPs or leave it blank to get 8.8.8.8, 1.1.1.1"
  }
}

variable "customer_side_asn" {
  description = "ASN to assign to Aviatrix Edge appliances at this location."
  type        = number
}

variable "equinix_metrocode" {
  description = "Equinix Metro code to deploy Aviatrix Edge."
  type        = string
}

variable "type_code" {
  description = "Equinix type code for Aviatrix Edge."
  default     = "AVIATRIX_EDGE"
  type        = string
}

variable "package_code" {
  description = "Equinix package code for Aviatrix Edge."
  default     = "STD"
  type        = string
}

variable "device_version" {
  description = "Base image version for Aviatrix Edge."
  default     = "6.9"
  type        = string
}

variable "core_count" {
  description = "Number of cores to assign to the Aviatrix Edge VM(s)."
  default     = 2
  type        = number
}

variable "term_length" {
  description = "Term length for the Aviatrix Edge VMs(s). Default: 1 month"
  default     = 1
  type        = number
}

variable "notifications" {
  description = "List of emails from which to receive Equinix notifications."
  type        = list(string)
}

variable "transit_connections" {
  description = "Underlay connects between Aviatrix Edge VM(s) and Transit Gateway VPCs."
  default     = {}
  type = map(object({
    base_circuit_name = optional(string, null),
    speed             = number,
    bgp_auth_key      = optional(string, null),
    vgw_asn           = optional(number, null),
    second_location   = optional(bool, null)
  }))
}


locals {
  primary = {
    name          = var.gw_name,
    wan_ip_prefix = "${cidrhost(local.wan_prefix, 2)}/${local.wan_prefixlen}",
    lan_ip_prefix = "${cidrhost(var.lan_interface_ip_prefix, 2)}/${local.lan_prefixlen}"
  }

  secondary = {
    name          = "${var.gw_name}-ha",
    wan_ip_prefix = "${cidrhost(local.wan_prefix, 3)}/${local.wan_prefixlen}"
    lan_ip_prefix = "${cidrhost(var.lan_interface_ip_prefix, 3)}/${local.lan_prefixlen}"
  }

  gateways = var.redundant ? merge(local.primary, local.secondary) : local.primary

  # Entire section could go away with 7.1 or at least need new logic.
  wan_prefix    = var.wan_interface_ip_prefix == null ? cidrsubnet("169.254.0.0/16", 13, random_integer.wan_cidr.result) : var.wan_interface_ip_prefix
  wan_prefixlen = split("/", local.wan_prefix)[1]
  wan_default   = cidrhost(local.wan_prefix, 1)

  lan_prefixlen = split("/", var.lan_interface_ip_prefix)[1]

  site_id         = coalesce(var.site_id, "equinix-${var.equinix_metrocode}")
  acl_name        = "${var.gw_name}-acl"
  acl_description = "ACL for ${var.gw_name}, primary and ha (if deployed.)"
}