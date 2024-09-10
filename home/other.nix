{ config, pkgs, lib, ... }:
with lib;
let
  gitModule.options = {
    enable = mkEnableOption {};
    userName = mkOption {
      type = types.str;
    };
    userEmail = mkOption {
      type = types.str;
    };
  };
in {
  options.programs.jlo.git = mkOption {
    type = types.submodule gitModule;
    default = {};
  };

  config = {
    home.packages = with pkgs; [
      azure-cli
      jmtpfs
      niv
    ];

    home.sessionVariables.EDITOR = "nvim";
    home.sessionVariables.GOPATH = "/home/jlo/.cache/go"; # TODO don't hardcode home path
    home.sessionVariables.ZELLIJ_AUTO_EXIT = "true";

    programs = {
      git = mkMerge [
        config.programs.jlo.git
        {
          package = pkgs.gitMinimal;
          aliases = {
            st = "status -s";
            co = "checkout";
          };
          extraConfig = {
            init.defaultBranch = "master";
            pull.rebase = false;
            push.default = "upstream";
          };
        }
      ];
    };

    # TODO Why is this always enabled?
    services.nextcloud-client.enable = true;
  };
}
