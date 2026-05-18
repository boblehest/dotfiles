{ ... }:
{
  virtualisation.incus = {
    enable = true;
    preseed = {
      storage_pools = [{
        name   = "default";
        driver = "dir";
      }];
      # Default profile attaches all instances to br-containers,
      # putting VMs on the same network as NixOS containers.
      profiles = [{
        name   = "default";
        config = {};
        devices = {
          eth0 = {
            type    = "nic";
            nictype = "bridged";
            parent  = "br-containers";
          };
          root = {
            type = "disk";
            path = "/";
            pool = "default";
          };
        };
      }];
    };
  };

  users.users.jlo.extraGroups = [ "incus-admin" ];
}
