terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "~> 0.1"
    }
  }
}

provider "incus" {
  # Connects to the local Incus socket by default when run on frodo.
  # To manage remotely from another machine, add a remote block:
  # remote {
  #   name    = "frodo"
  #   address = "https://frodo:8443"
  # }
}
