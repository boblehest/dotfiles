{ config, lib, pkgs, ... }:
let
  cfg = config.services.jlo.wireguard;
in
  with lib;
{
  options.services.jlo.wireguard = {
    enable = mkEnableOption "WireGuard Server";
    wanInterface = mkOption {
      type = types.str;
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
    # TODO Replace by "mode" or something which can be either "server" or "client".
    # This here is what we call boolean blindness.
    isServer = mkOption {
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    networking.nat = mkIf cfg.isServer {
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
          inherit (cfg) listenPort peers privateKeyFile;
          ips = [ cfg.ipAddressWithSubnet ];
        } (mkIf (cfg.isServer && config.networking.firewall.enable) {
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

