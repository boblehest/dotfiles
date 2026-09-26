{ ... }:
{
  # Hosts without a persistent ssh host key (e.g. desktops without sshd) get a
  # dedicated age key generated on first activation instead of deriving one
  # via ssh-to-age. See .sops.yaml for which hosts are set up as recipients.
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
}
