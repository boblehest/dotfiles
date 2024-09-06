{ pkgs, lib, secretCfg, ... }:

{
  home.packages = with pkgs; [
    azure-cli
    jmtpfs
    niv
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.GOPATH = "/home/jlo/.cache/go"; # TODO don't hardcode home path
  home.sessionVariables.ZELLIJ_AUTO_EXIT = "true";

  programs = {
    git = lib.mkMerge [
      secretCfg.git
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

  services.nextcloud-client.enable = true;
}
