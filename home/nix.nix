{ ... }:

{
  # Applies allowUnfree for nix-shell invocations outside of NixOS.
  # The NixOS-level config (system/common.nix) covers everything else.
  xdg.configFile."nixpkgs/config.nix".text = ''
    { allowUnfree = true; sandbox = true; }
  '';
}
