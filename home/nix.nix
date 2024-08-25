{ ... }:

{
  # TODO 2024-05-09 This is configured both system-wide (in system/common.nix) and
  # for the user here. Is this duplication necessary?
  # TODO On my work pc I set
  # xdg.configFile."nixpkgs/config.nix".source = ...
  # Why? Did it help?
  nixpkgs = {
    config = {
      allowUnfree = true;
      sandbox = true;
    };
  };
  setFlakeRegistry = false;
  setNixPath = false;
}
