{ config, lib, pkgs, ... }:
let
  cfg = config.my.services.wireguard;

  # The single VPN server, as seen from every client. Clients route the VPN
  # subnet and frodo's container network (*.home resolves into it) through it.
  serverPeer = {
    publicKey = "ZtRsDJHYOCowc/h5ZaZC+28aiuksvNyJ0fr/DfGjuyA="; # frodo
    allowedIPs = [ "10.13.37.0/24" "10.0.0.0/24" ];
    endpoint = "lavpan.net:43434";
    # Keep re-resolving the endpoint: retries until DNS works at boot (the
    # network-online.target ordering is meaningless with wait-online disabled
    # below), and follows home IP changes and laptops switching networks.
    dynamicEndpointRefreshSeconds = 60;
    dynamicEndpointRefreshRestartSeconds = 10;
  };
in
  with lib;
{
  options.my.services.wireguard = {
    enable = mkEnableOption "WireGuard Server";
    wanInterface = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    vpnInterface = mkOption {
      type = types.str;
    };
    listenPort = mkOption {
      type = types.port;
    };
    ipAddressWithSubnet = mkOption {
      type = types.str;
    };
    peers = mkOption {
      type = types.listOf types.attrs;
    };
    privateKeyFile = mkOption {
      type = types.path;
    };
    peerType = mkOption {
      type = types.enum ["client" "server"];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.peerType == "server") == (cfg.wanInterface != null);
        message = "`wanInterface` should be non-null iff `peerType` is server";
      }
    ];
    # NOTE 2024-05-09 I'm having issue with nixos-rebuild because the
    # NetworkManager-wait-online service fails. I'm not sure what causes it, but
    # I assumed it was my wireguard interface, and hoped that adding the wg interface
    # to `networking.networkmanager.unmanaged` would help, but it does not, so
    # I've disabled the wait-online service for now, unsure if it's useful for anything.
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

    networking.nat = mkIf (cfg.peerType == "server") {
      enable = true;
      externalInterface = cfg.wanInterface;
      internalInterfaces = [ cfg.vpnInterface ];
    };
    networking.firewall = mkIf config.networking.firewall.enable {
      allowedUDPPorts = [ cfg.listenPort ];
    };

    networking.wireguard.interfaces = {
      ${cfg.vpnInterface} = mkMerge [
        {
          inherit (cfg) listenPort privateKeyFile;
          ips = [ cfg.ipAddressWithSubnet ];
          peers = map (peerCfg: mkMerge [
            peerCfg
            (mkIf (cfg.peerType == "client") {
              persistentKeepalive = 25;
            })
          ]) (if cfg.peerType == "client" then [ serverPeer ] else cfg.peers);
        }
        (mkIf (cfg.peerType == "client") {
          postSetup = ''
            ${pkgs.systemd}/bin/resolvectl dns ${cfg.vpnInterface} 10.13.37.1
            ${pkgs.systemd}/bin/resolvectl domain ${cfg.vpnInterface} "~home"
          '';
          postShutdown = ''
            ${pkgs.systemd}/bin/resolvectl revert ${cfg.vpnInterface}
          '';
        })
        (mkIf (cfg.peerType == "server" && config.networking.firewall.enable) {
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.ipAddressWithSubnet} -o ${cfg.wanInterface} -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${cfg.ipAddressWithSubnet} -o ${cfg.wanInterface} -j MASQUERADE
          '';
        })
      ];
    };
  };
}

