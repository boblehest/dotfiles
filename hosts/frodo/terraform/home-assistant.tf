# Before applying, import the Home Assistant OS image into Incus:
#   incus image import haos_ova-<version>.ova.gz --alias home-assistant-os
#
# The VM uses br-lan (bridged to eno2) so it appears directly on the LAN
# (192.168.10.0/24). This is required for Matter/Thread multicast to work.

resource "incus_instance" "home_assistant" {
  name     = "home-assistant"
  type     = "virtual-machine"
  image    = "home-assistant-os"
  profiles = [] # explicit NIC below; don't inherit default profile's br-containers NIC

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

  # NIC directly on the LAN bridge so HAOS participates in link-local multicast
  # (required for Matter/Thread and companion app discovery)
  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = "br-lan"
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
