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
  options.programs.my.git = mkOption {
    type = types.submodule gitModule;
    default = {};
  };

  config = {
    home.packages = with pkgs; [
      jmtpfs
      jq
      yq

      # TODO Move into jlo-zrch config
      slack
      vault
      lens # k8s gui
      kubectl # needed by lens
      kubelogin-oidc # needed by lens
      dbeaver-bin
    ];

    home.sessionVariables.EDITOR = "nvim";
    home.sessionVariables.GOPATH = "/home/jlo/.cache/go"; # TODO don't hardcode home path

    programs = {
      git = mkMerge [
        config.programs.my.git
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
            url = {
              # TODO Could this be in work devshells instead of being globally configured like this?
              "git@gitlab.zrch.cloud:" = {
                insteadOf = [
                  "https://gitlab.com/"
                  "https://gitlab.zrch.cloud/"
                ];
              };
            };
          };
        }
      ];
    };

    # TODO Why is this always enabled?
    services.nextcloud-client.enable = true;
  };
}
