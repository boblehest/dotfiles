{ config, lib, ... }:
let
  cfg = config.my.publicServices;
  stateVersion = config.my.stateVersion;

  # Podman publishes each service on the host's bridge address, where the proxy
  # container can reach it. Never on the LAN/WAN address.
  upstream = svc: "http://${cfg.hostAddress}:${toString svc.hostPort}";

  serviceOpts = { name, ... }: {
    options = with lib; {
      image = mkOption {
        type = types.str;
        example = "registry.gitlab.com/me/app:main";
        description = ''
          Image to run. Use a floating tag (e.g. `:main`): podman auto-update
          pulls it again whenever the tag points to a new digest, and restarts
          the service.
        '';
      };
      domain = mkOption {
        type = types.str;
        example = "app.example.com";
      };
      port = mkOption {
        type = types.port;
        description = "Port the app listens on inside its container.";
      };
      hostPort = mkOption {
        type = types.port;
        description = "Port on `hostAddress` the proxy reaches the app through. Must be unique.";
      };
      environment = mkOption {
        type = types.attrsOf types.str;
        default = {};
      };
      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [];
        description = "E.g. sops secret paths.";
      };
      volumes = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/srv/app:/data" ];
      };
    };
  };
in
  with lib;
{
  options.my.publicServices = {
    enable = mkEnableOption "internet-facing services (podman apps behind a public nginx)";
    acmeEmail = mkOption {
      type = types.str;
    };
    bridge = mkOption {
      type = types.str;
      default = "br-containers";
    };
    hostAddress = mkOption {
      type = types.str;
      default = "10.0.0.1";
      description = "The host's address on `bridge`.";
    };
    proxyAddress = mkOption {
      type = types.str;
      default = "10.0.0.7";
      description = "Address of the public nginx container on `bridge`.";
    };
    autoUpdateInterval = mkOption {
      type = types.str;
      default = "*:0/5";
      description = "systemd OnCalendar for checking the registry for new images.";
    };
    registryLogin = mkOption {
      type = types.nullOr (types.submodule {
        options = {
          registry = mkOption { type = types.str; default = "registry.gitlab.com"; };
          username = mkOption { type = types.str; };
          passwordFile = mkOption { type = types.path; };
        };
      });
      default = null;
      description = "Credentials for private images, e.g. a read-only GitLab deploy token.";
    };
    services = mkOption {
      type = types.attrsOf (types.submodule serviceOpts);
      default = {};
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = let ports = mapAttrsToList (_: s: s.hostPort) cfg.services;
                  in length ports == length (unique ports);
      message = "my.publicServices: hostPort values must be unique";
    }];

    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = mapAttrs (_: svc: {
      inherit (svc) image environment environmentFiles volumes;
      ports = [ "${cfg.hostAddress}:${toString svc.hostPort}:${toString svc.port}" ];
      labels."io.containers.autoupdate" = "registry";
    } // optionalAttrs (cfg.registryLogin != null) {
      # podman login writes root's default auth file, which auto-update reuses
      login = cfg.registryLogin;
    }) cfg.services;

    # Binding to hostAddress fails until the bridge has its address
    systemd.services = mapAttrs' (name: _: nameValuePair "podman-${name}" {
      after = [ "network-addresses-${cfg.bridge}.service" ];
      wants = [ "network-addresses-${cfg.bridge}.service" ];
    }) cfg.services;

    # Upstream timer runs daily with a 15 min random delay; this is our deploy
    # mechanism, so run it often and promptly. The empty string resets
    # upstream's OnCalendar instead of adding to it.
    systemd.timers.podman-auto-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = [ "" cfg.autoUpdateInterval ];
        RandomizedDelaySec = "0";
      };
    };

    # The router forwards 80/443 to frodo; send them on to the proxy.
    # NB: this DNATs every packet arriving on the external interface with these
    # ports, whatever its destination address.
    networking.nat.forwardPorts = map (port: {
      proto = "tcp";
      sourcePort = port;
      destination = "${cfg.proxyAddress}:${toString port}";
    }) [ 80 443 ];

    # A separate nginx from the host's internal one, so nothing internal is
    # reachable from the internet by spoofing a Host header.
    containers.public-proxy = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = cfg.bridge;
      localAddress = "${cfg.proxyAddress}/24";
      config = {
        system.stateVersion = stateVersion;

        security.acme = {
          acceptTerms = true;
          defaults.email = cfg.acmeEmail;
        };

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          virtualHosts = {
            # Drop requests for any other hostname (scanners hitting the bare IP)
            "_" = {
              default = true;
              rejectSSL = true;
              locations."/".return = "444";
            };
          } // mapAttrs' (_: svc: nameValuePair svc.domain {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyPass = upstream svc;
              proxyWebsockets = true;
            };
          }) cfg.services;
        };

        networking.defaultGateway = cfg.hostAddress;
        networking.firewall.allowedTCPPorts = [ 80 443 ];
      };
    };
  };
}
