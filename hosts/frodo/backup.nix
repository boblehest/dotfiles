{ config, pkgs, ... }:
let
  # The Storage Box key for this repo is restricted in its authorized_keys to
  #   command="borg-1.4 serve --append-only --restrict-to-repository backups/frodo",restrict
  # so this host can only append. Pruning/compacting must be done from an
  # unrestricted admin client, which is why no prune.keep is set below.
  common = {
    repo = "ssh://u712029@u712029.your-storagebox.de:23/./backups/frodo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.sops.secrets.borg-passphrase.path}";
    };
    environment = {
      BORG_RSH = "ssh -i ${config.sops.secrets.borg-ssh-key.path} -o IdentitiesOnly=yes";
      BORG_REMOTE_PATH = "borg-1.4";
    };
    compression = "auto,zstd";
    # Init once by hand (`sudo borg-job-nextcloud init -e repokey-blake2`);
    # auto-init would silently create a fresh, empty repo if the real one ever
    # went missing.
    doInit = false;
    persistentTimer = true;
    # Both jobs share the repo; wait for the other one's lock instead of failing.
    extraArgs = [ "--lock-wait" "3600" ];
  };
  occ = "${pkgs.nixos-container}/bin/nixos-container run nextcloud -- nextcloud-occ";
in
{
  sops.secrets.borg-passphrase = {};
  sops.secrets.borg-ssh-key = {};

  programs.ssh.knownHosts."[u712029.your-storagebox.de]:23".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";

  services.borgbackup.jobs = {
    nextcloud = common // {
      paths = [ "/srv/nextcloud" ];
      startAt = "*-*-* 03:00:00";
      # Keeps files and the SQLite DB consistent with each other during the
      # backup. postHook runs on exit even if the backup fails.
      preHook = "${occ} maintenance:mode --on";
      postHook = "${occ} maintenance:mode --off";
    };
    music = common // {
      paths = [ "/srv/music" ];
      startAt = "*-*-* 04:00:00";
    };
  };
}
