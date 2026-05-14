{ pkgs, lib, secretCfg, ... }:

  {
    home.sessionVariables.EDITOR = "nvim";

    programs = {
      git = lib.mkMerge [ secretCfg.git {
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
        signing.format = null;
      }];
    };
  }
