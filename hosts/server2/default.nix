{ pkgs, ... }:
{
  config.my = {
    username = "jlo";
    hostName = "server2"; # TODO: verify actual hostname
    stateVersion = "23.11"; # TODO: verify — was previously in /etc/nixos/dotfiles/settings.nix
    videoDrivers = [];
    features = {
      desktop = false;
      sleep = false;
    };
  };

  config.my.services.wireguard = {
    enable = true;
    peerType = "server";
    wanInterface = "enp1s0f1";
    vpnInterface = "wg0";
    ipAddressWithSubnet = "10.13.37.1/24";
    listenPort = 43434;
    privateKeyFile = "/etc/wireguard-key"; # TODO: move into secrets management
    peers = [
      { # old laptop
        publicKey = "DQwMJJX6jIwjQU61Kn1MhnT/fX2H9gu6CkwhJIMwu3M=";
        allowedIPs = [ "10.13.37.2/32" ];
      }
      { # zrch laptop
        publicKey = "uFg7sGA178GsqDuz9SS5gldQ1yXGwkuPi3U4SDuK3lA=";
        allowedIPs = [ "10.13.37.3/32" ];
      }
      { # own s10 phone
        publicKey = "8PvKXOntHBI7oszz6/s0K3FdGm0GnETFkM9reX3ObwM=";
        allowedIPs = [ "10.13.37.4/32" ];
      }
      { # Johannes laptop
        publicKey = "Vk94F/yTIllVCedx4BngUZSWU62Kybw3b3gox1+nyAc=";
        allowedIPs = [ "10.13.37.5/32" ];
      }
      { # Johannes phone
        publicKey = "GeNfaUiBIuLk/CZqwb4SDTYW1Jx9L1XTJnzM4C2NMC4=";
        allowedIPs = [ "10.13.37.6/32" ];
      }
    ];
  };

  config.my.services.mediaserver.enable = true;

  config.services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33; # TODO: bump when upgrading
    hostName = "10.13.37.1";
    config.adminpassFile = "/etc/nextcloud-admin-pass"; # TODO: move into secrets management
    config.dbtype = "sqlite";
  };

  config.services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  config.users.users.jlo.openssh.authorizedKeys.keys = [
    # jlo-laptop
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXp3Qko56ohPkFp/BREu/1DcHiYBFnL40AdmCbI9CPo93h5/lnT+GOBf1LTT96HIGoVRggKMRnwIhGB8gF5DDqEzOrQ4bRKf3tdbSWrmJoO9Gv9wFoTYlMyfpLYjDbz4LoUhumqZJ9PfaTyODVAhVkyobTiuo5EJ+fZhHbjkDpI1xFSSHezssavPsSXYKj0AFmz2++02hfzImEfrY/nqTYgsd4v3j7s/G/o9VluoqeeklLHBXHhiIsvZnmec99AP3zBAbJIlaGE+dQW4wWc/3Mzgy1S9+EU5l291xW50YuqQC9V1wSLxF7mN3LK0fiEMyy9Li8LDH+w6OrmeByDNovTUjxNduvdnaL2pvjwIekOAvdhpnWOtcCFI6m355MHVqqW7q2PetGaZCpdeDDVZ4pHwW/vpXdqGnVr61FytVudtjxIy5NmGASsIvNFauuDYNQeiDAQ0s613CjOT4GmLN2nUnd0ZXAmV2AG2HE41SLinR+/NNdtOmzBqwaO9Ld4pcCLJeOs+SSQ3/hUs5XwMNsnHjrAFa/3YxMH9DbyfZji/9Mz69xdpxmd9q43BcPNp9cKBNBv51LA5XCikUm2b0I/IEeqj22OVfVytMnMm5xK1bdJGbW6Q28YnOev3wxQ3gTIxXhJbmGeXdQZ3zTNax7HJvbmljii7IIoJOLZq+KaQ== jlode90@gmail.com"
    # jlo-zrch
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzPHjc6wTtzHsyNGERifEt/3V69nTkcyh2gEGaNbsyD jl@zrch.com"
  ];

  config.my.users.jlo.hm-config = import ../../home;

  config.home-manager.users.jlo = {
    my.latex = false;
    programs.my.git = {
      enable = true;
      userName = "Jørn Lode";
      userEmail = "jlode90@gmail.com";
    };
  };
}
