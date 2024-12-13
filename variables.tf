variable "name" {
  description = "Name for the Megaport Gateway."
  type        = string
}

variable "account" {
  description = "Megaport account on the Aviatrix controller."
  type        = string
}

variable "site_id" {
  description = "Site ID for the gateway(s)."
  type        = string
}

variable "prepend_as_path" {
  description = "List of AS numbers to prepend gateway BGP AS_Path field. Valid only when local_as_number is set. Example: [\"65023\", \"65023\"]."
  type        = list(number)
  default     = null
}

variable "local_as_number" {
  description = "BGP AS Number to assign to Edge VM."
  type        = number
  default     = null
}

variable "enable_learned_cidrs_approval" {
  description = "Switch to enable learned CIDR approval."
  type        = bool
  default     = null
}

variable "approved_learned_cidrs" {
  description = "Set of approved learned CIDRs. Valid only when enable_learned_cidrs_approval is set to true. Example: [\"10.1.0.0/16\", \"10.2.0.0/16\"]."
  type        = list(string)
  default     = null
}

variable "lan_ip" {
  description = "LAN Interface static IP address. Example: \"192.168.1.1/24\"."
  type        = string
}

variable "wan1_ip" {
  description = "WAN 1 Interface static IP address. Example: \"192.168.2.1/24\"."
  type        = string
}

variable "wan1_gateway_ip" {
  description = "WAN 1 Interface gateway IP. Example: \"192.168.2.254\"."
  type        = string
}

variable "wan1_public_ip" {
  description = "WAN 1 public IP."
  type        = string
  default     = null
}

variable "ha_lan_ip" {
  description = "LAN Interface static IP address. Example: \"192.168.1.1/24\"."
  type        = string
  default     = ""
  nullable    = false
}

variable "ha_wan1_ip" {
  description = "WAN 1 Interface static IP address. Example: \"192.168.2.1/24\"."
  type        = string
  default     = ""
  nullable    = false
}

variable "ha_wan1_gateway_ip" {
  description = "WAN 1 Interface gateway IP. Example: \"192.168.2.254\"."
  type        = string
  default     = ""
  nullable    = false
}

variable "ha_wan1_public_ip" {
  description = "WAN 1 public IP."
  type        = string
  default     = ""
  nullable    = false
}

variable "ha_gw" {
  description = "Enables creation of a second Megaport gateway."
  default     = false
  type        = bool
  nullable    = false
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

variable "equinix_metro_code" {
  description = "Equinix Metro code to deploy Aviatrix Edge."
  type        = string
}

variable "equinix_account_id" {
  description = "ID of the Equinix account"
  type        = string
}

variable "device_version" {
  description = "Base image version for Aviatrix Edge."
  default     = "7.1.d"
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
