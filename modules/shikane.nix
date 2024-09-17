{ config, lib, pkgs, ... }:
with { inherit (lib) mkOption mkEnableOption types; };
let
  cfg = config.services.jlo.shikane;
in
{
  options.services.jlo.shikane = {
    enable = mkEnableOption {};
    systemdTarget = mkOption {
      type = types.str;
      default = "sway-session.target";
      description = ''
        Systemd target to bind to.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.shikane;
      defaultText = literalExpression "pkgs.shikane";
      description = ''
        shikane derivation to use.
      '';
    };
  };
  config = let
    configPath = "${config.xdg.configHome}/shikane/config.yaml";
  in {
    home.activation = {
      activateShikaneConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p ${builtins.dirOf configPath}
        run touch ${configPath}
      '';
    };

    systemd.user.services.shikane = {
      Unit = {
        Description = "Dynamic output configuration";
        Documentation = "man:shikane(1)";
        PartOf = cfg.systemdTarget;
        Requires = cfg.systemdTarget;
        After = cfg.systemdTarget;
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/shikane -c ${configPath}";
        Restart = "always";
      };

      Install = { WantedBy = [ cfg.systemdTarget ]; };
    };
    home.packages = [
      pkgs.shikane # For the CLI (saving profiles)
      pkgs.nwg-displays # for output configuration
    ];
  };
}
