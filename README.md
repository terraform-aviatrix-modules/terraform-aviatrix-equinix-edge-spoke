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
| <a name="input_account"></a> [account](#input\_account) | Megaport account on the Aviatrix controller. | `string` | n/a | yes |
| <a name="input_approved_learned_cidrs"></a> [approved\_learned\_cidrs](#input\_approved\_learned\_cidrs) | Set of approved learned CIDRs. Valid only when enable\_learned\_cidrs\_approval is set to true. Example: ["10.1.0.0/16", "10.2.0.0/16"]. | `list(string)` | `null` | no |
| <a name="input_core_count"></a> [core\_count](#input\_core\_count) | Number of cores to assign to the Aviatrix Edge VM(s). | `number` | `2` | no |
| <a name="input_device_version"></a> [device\_version](#input\_device\_version) | Base image version for Aviatrix Edge. | `string` | `"7.1"` | no |
| <a name="input_dns_server_ips"></a> [dns\_server\_ips](#input\_dns\_server\_ips) | List of exactly 2 DNS server IPs. Default: 8.8.8.8, 1.1.1.1 | `list(string)` | <pre>[<br/>  "8.8.8.8",<br/>  "1.1.1.1"<br/>]</pre> | no |
| <a name="input_enable_learned_cidrs_approval"></a> [enable\_learned\_cidrs\_approval](#input\_enable\_learned\_cidrs\_approval) | Switch to enable learned CIDR approval. | `bool` | `null` | no |
| <a name="input_equinix_account_id"></a> [equinix\_account\_id](#input\_equinix\_account\_id) | ID of the Equinix account | `string` | n/a | yes |
| <a name="input_equinix_metro_code"></a> [equinix\_metro\_code](#input\_equinix\_metro\_code) | Equinix Metro code to deploy Aviatrix Edge. | `string` | n/a | yes |
| <a name="input_ha_gw"></a> [ha\_gw](#input\_ha\_gw) | Enables creation of a second Megaport gateway. | `bool` | `false` | no |
| <a name="input_ha_lan_ip"></a> [ha\_lan\_ip](#input\_ha\_lan\_ip) | LAN Interface static IP address. Example: "192.168.1.1/24". | `string` | `""` | no |
| <a name="input_ha_wan1_gateway_ip"></a> [ha\_wan1\_gateway\_ip](#input\_ha\_wan1\_gateway\_ip) | WAN 1 Interface gateway IP. Example: "192.168.2.254". | `string` | `""` | no |
| <a name="input_ha_wan1_ip"></a> [ha\_wan1\_ip](#input\_ha\_wan1\_ip) | WAN 1 Interface static IP address. Example: "192.168.2.1/24". | `string` | `""` | no |
| <a name="input_ha_wan1_public_ip"></a> [ha\_wan1\_public\_ip](#input\_ha\_wan1\_public\_ip) | WAN 1 public IP. | `string` | `""` | no |
| <a name="input_lan_ip"></a> [lan\_ip](#input\_lan\_ip) | LAN Interface static IP address. Example: "192.168.1.1/24". | `string` | n/a | yes |
| <a name="input_local_as_number"></a> [local\_as\_number](#input\_local\_as\_number) | BGP AS Number to assign to Edge VM. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the Megaport Gateway. | `string` | n/a | yes |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | List of emails from which to receive Equinix notifications. | `list(string)` | n/a | yes |
| <a name="input_prepend_as_path"></a> [prepend\_as\_path](#input\_prepend\_as\_path) | List of AS numbers to prepend gateway BGP AS\_Path field. Valid only when local\_as\_number is set. Example: ["65023", "65023"]. | `list(number)` | `null` | no |
| <a name="input_site_id"></a> [site\_id](#input\_site\_id) | Site ID for the gateway(s). | `string` | n/a | yes |
| <a name="input_term_length"></a> [term\_length](#input\_term\_length) | Term length for the Aviatrix Edge VMs(s). Default: 1 month | `number` | `1` | no |
| <a name="input_wan1_gateway_ip"></a> [wan1\_gateway\_ip](#input\_wan1\_gateway\_ip) | WAN 1 Interface gateway IP. Example: "192.168.2.254". | `string` | n/a | yes |
| <a name="input_wan1_ip"></a> [wan1\_ip](#input\_wan1\_ip) | WAN 1 Interface static IP address. Example: "192.168.2.1/24". | `string` | n/a | yes |
| <a name="input_wan1_public_ip"></a> [wan1\_public\_ip](#input\_wan1\_public\_ip) | WAN 1 public IP. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_equinix_network_device"></a> [equinix\_network\_device](#output\_equinix\_network\_device) | n/a |
<!-- END_TF_DOCS -->