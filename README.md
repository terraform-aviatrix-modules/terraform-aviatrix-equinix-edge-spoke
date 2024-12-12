<!-- BEGIN_TF_DOCS -->
# terraform-aviatrix-equinix-edge-spoke

### Description
This module deploys the Aviatrix Edge Gateway in a Megaport location. It can take between 15 and 60 minutes after the deployment has completed, before you will see the gateway be in the "Up" state in the controller.

### Compatibility
Module | Terraform | Controller | Aviatrix Terraform provider | Megaport  Terraform provider
:--- | :--- | :--- | :--- | :---
v1.1.1 | >=1.3 | 7.2 | ~> 3.2.0 | >= 1.2.1

### Usage Example
```hcl

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_core_count"></a> [core\_count](#input\_core\_count) | Number of cores to assign to the Aviatrix Edge VM(s). | `number` | `2` | no |
| <a name="input_customer_side_asn"></a> [customer\_side\_asn](#input\_customer\_side\_asn) | ASN to assign to Aviatrix Edge appliances at this location. | `number` | n/a | yes |
| <a name="input_device_version"></a> [device\_version](#input\_device\_version) | Base image version for Aviatrix Edge. | `string` | `"7.1"` | no |
| <a name="input_dns_server_ips"></a> [dns\_server\_ips](#input\_dns\_server\_ips) | List of exactly 2 DNS server IPs. Default: 8.8.8.8, 1.1.1.1 | `list(string)` | <pre>[<br/>  "8.8.8.8",<br/>  "1.1.1.1"<br/>]</pre> | no |
| <a name="input_equinix_metrocode"></a> [equinix\_metrocode](#input\_equinix\_metrocode) | Equinix Metro code to deploy Aviatrix Edge. | `string` | n/a | yes |
| <a name="input_gw_name"></a> [gw\_name](#input\_gw\_name) | Name of the Aviatrix Edge gateway to deploy. | `string` | n/a | yes |
| <a name="input_lan_interface_ip_prefix"></a> [lan\_interface\_ip\_prefix](#input\_lan\_interface\_ip\_prefix) | CIDR range to use on the LAN interface of the Aviatrix Edge VM. | `string` | n/a | yes |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | List of emails from which to receive Equinix notifications. | `list(string)` | n/a | yes |
| <a name="input_package_code"></a> [package\_code](#input\_package\_code) | Equinix package code for Aviatrix Edge. | `string` | `"STD"` | no |
| <a name="input_redundant"></a> [redundant](#input\_redundant) | Deploy redundant Aviatrix Edge Gateways. | `bool` | `true` | no |
| <a name="input_site_id"></a> [site\_id](#input\_site\_id) | Site ID in Aviatrix Controller. Default: Equinix-<metrocode>. | `string` | `""` | no |
| <a name="input_term_length"></a> [term\_length](#input\_term\_length) | Term length for the Aviatrix Edge VMs(s). Default: 1 month | `number` | `1` | no |
| <a name="input_transit_connections"></a> [transit\_connections](#input\_transit\_connections) | Underlay connects between Aviatrix Edge VM(s) and Transit Gateway VPCs. | <pre>map(object({<br/>    base_circuit_name = optional(string, null),<br/>    speed             = number,<br/>    bgp_auth_key      = optional(string, null),<br/>    vgw_asn           = optional(number, null),<br/>    second_location   = optional(bool, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_type_code"></a> [type\_code](#input\_type\_code) | Equinix type code for Aviatrix Edge. | `string` | `"AVIATRIX_EDGE"` | no |
| <a name="input_wan_interface_ip_prefix"></a> [wan\_interface\_ip\_prefix](#input\_wan\_interface\_ip\_prefix) | CIDR range to use on the WAN interface of the Aviatrix Edge VM. Default: Random /29 CIDR in 169.254 range. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aviatrix_edge_spoke"></a> [aviatrix\_edge\_spoke](#output\_aviatrix\_edge\_spoke) | n/a |
| <a name="output_equinix_network_device"></a> [equinix\_network\_device](#output\_equinix\_network\_device) | n/a |
<!-- END_TF_DOCS -->