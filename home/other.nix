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
  options.my.programs.git = mkOption {
    type = types.submodule gitModule;
    default = {};
  };

  config = {
    home.packages = with pkgs; [
      jmtpfs
      jq
      yq
    ];

    home.sessionVariables.EDITOR = "nvim";
    home.sessionVariables.GOPATH = "${config.home.homeDirectory}/.cache/go";

    programs = {
      git = mkMerge [
        config.my.programs.git
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

  };
}
