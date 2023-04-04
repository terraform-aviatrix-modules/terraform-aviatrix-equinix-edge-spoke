# terraform-aviatrix-equinix

Terraform module to deploy Aviatrix Edge in Equinix Edge.

### Compatibility
Module version | Terraform version | Aviatrix Provider version | Equinix provider version
:--- | :--- | :--- | :---
v0.9.0 | >=1.3.0 | >= 3.0.0 | >= 1.13.0

Check [release notes](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-dx-underlay/blob/master/RELEASE_NOTES.md) for more details.
Check [Compatibility list](https://github.com/terraform-aviatrix-modules/terraform-aviatrix-dx-underlay/blob/master/COMPATIBILITY.md) for older versions.

### Required variables
Key | Default value | Description
:-- | --: | :--
gw_name | | Name of the gateway(s) to deploy.
site_id | Equinix-\<metrocode\> | Name of the site
redundant | true | Deploy 1 or 2 gateways.
wan_interface_ip_prefix | Random 169.254.0.0 CIDR | IP cidr to use for WAN interface(s)
lan_interface_ip_prefix | | IP CIDR to use for LAN Interface
dns_server_ips | [8.8.8.8, 1.1.1.1] | DNS Server IPs for Edge VM(s)
customer_side_asn | | ASN to use for Aviatrix Edge
equinix_metrocode | | Equinix metrocode to deploy resources
type_code | AVIATRIX_EDGE | Equinix type code for Aviatrix Edge
package_code | STD | Equinix package code for Aviatrix Edge
device_version | 6.9 | Aviatrix Edge image to deploy
notifications | | List of emails for Equinix notifications
transit_connections | | See object structure below.

### Transit Connections
Key | Description
:-- | :--
\<Aviatrix Transit Gateway Name\> | The name of the Transit Gateway to attach to.

Subkey | Default Value | Description
:-- | :-- | :--
speed | | Speed in megabit, ie 50, 100, 1000
customer_side_asn | | ASN to use for Aviatrix Edge
bgp_auth_key | aviatrix1234#! | Key to use for BGP authentication
vgw_asn | 64512 | AWS: VGW ASN
second_location | False | Azure: False | Use the second ExpressRoute location - ie London vs London2.