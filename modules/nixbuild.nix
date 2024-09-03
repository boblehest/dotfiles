{ config, lib, ... }:
with lib;

let
  cfg = config.midgard.pc.nixbuild;
in {
  options.midgard.pc.nixbuild = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = " Turn on remote build on nixbuild.net";
    };

    sshKeyPath = mkOption {
      type = types.str;
      default = "/etc/ssh/nixbuild";
      description = ''
        Path to your private ssh key for your nixbuild account. It will be set
        automaticly if you set secert nixbuild-ssh in secrets.yaml
      '';
    };
  };

  config = mkIf cfg.enable {
    # sops.secrets."nixbuild-ssh" = {
    #   path = "/etc/ssh/nixbuild";
    # };
    #
    programs.ssh.extraConfig = ''
    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile ${cfg.sshKeyPath}
    '';

    programs.ssh.knownHosts = {
      nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };
    };

    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "eu.nixbuild.net";
          system = "x86_64-linux";
          maxJobs = 100;
          supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
        }
        {
          hostName = "eu.nixbuild.net";
          system = "aarch64-linux";
          maxJobs = 100;
          supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
        }
      ];
      settings = { # Use nixbuild as subsituter
        substituters = lib.mkOrder 2000 [ "ssh://eu.nixbuild.net" ];
        trusted-public-keys = [ "nixbuild.net/eviny-1:szqbKzWjc/GMADWn3BYNEDj6HGPPcSAdzH1DX12Blu0=" ];
      };
    };
  };

}
