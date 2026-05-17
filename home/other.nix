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
        {
          enable = config.my.programs.git.enable;
          settings.user.name  = config.my.programs.git.userName;
          settings.user.email = config.my.programs.git.userEmail;
        }
        {
          package = pkgs.gitMinimal;
          settings = {
            alias = {
              st = "status -s";
              co = "checkout";
            };
            init.defaultBranch = "master";
            pull.rebase = false;
            push.default = "upstream";
          };
        }
      ];
    };

  };
}
