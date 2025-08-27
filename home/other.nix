{ pkgs, lib, secretCfg, ... }:

  {
    home.sessionVariables.EDITOR = "nvim";

    programs = {
      git = lib.mkMerge [ secretCfg.git {
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
      }];
    };
  }
