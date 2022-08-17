{ pkgs, lib, ... }:

{
  execute = cmd:
    lib.hm.dag.entryAfter [ "installPackages" ] ''
      ${cmd}
    '';
}
