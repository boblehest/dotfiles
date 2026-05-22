# Before applying, import the Home Assistant OS image into Incus:
#   incus image import haos_ova-<version>.ova.gz --alias home-assistant-os
#
# The VM uses the default Incus profile, which attaches it to br-containers
# and places it on the 10.0.0.0/24 network alongside the NixOS containers.
# Configure a static IP (e.g. 10.0.0.10) in HAOS's Network settings after
# first boot, since there is no DHCP server on the bridge.

resource "incus_instance" "home_assistant" {
  name  = "home-assistant"
  type  = "virtual-machine"
  image = "home-assistant-os"

  config = {
    "limits.cpu"          = "2"
    "limits.memory"       = "2GiB"
    "security.secureboot" = "false"
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      pool = "default"
      path = "/"
      size = "32GiB"
    }
  }

  device {
    name = "zbt2"
    type = "usb"
    properties = {
      vendorid  = "303a"
      productid = "831a"
    }
  }
}
