terraform {
  required_providers {
    aviatrix = {
      source  = "aviatrixsystems/aviatrix"
      version = ">=3.0.0"
    }
    equinix = {
      source  = "equinix/equinix"
      version = ">=1.3.0"
    }
  }
  required_version = ">= 0.13"
}
