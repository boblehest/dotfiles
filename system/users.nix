{ pkgs, secretCfg, ... }:

{
  users.users."${secretCfg.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "plugdev" "dialout" ];
    shell = pkgs.fish;
    initialHashedPassword = "";
    openssh.authorizedKeys.keys = [
      # jlo-laptop
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXp3Qko56ohPkFp/BREu/1DcHiYBFnL40AdmCbI9CPo93h5/lnT+GOBf1LTT96HIGoVRggKMRnwIhGB8gF5DDqEzOrQ4bRKf3tdbSWrmJoO9Gv9wFoTYlMyfpLYjDbz4LoUhumqZJ9PfaTyODVAhVkyobTiuo5EJ+fZhHbjkDpI1xFSSHezssavPsSXYKj0AFmz2++02hfzImEfrY/nqTYgsd4v3j7s/G/o9VluoqeeklLHBXHhiIsvZnmec99AP3zBAbJIlaGE+dQW4wWc/3Mzgy1S9+EU5l291xW50YuqQC9V1wSLxF7mN3LK0fiEMyy9Li8LDH+w6OrmeByDNovTUjxNduvdnaL2pvjwIekOAvdhpnWOtcCFI6m355MHVqqW7q2PetGaZCpdeDDVZ4pHwW/vpXdqGnVr61FytVudtjxIy5NmGASsIvNFauuDYNQeiDAQ0s613CjOT4GmLN2nUnd0ZXAmV2AG2HE41SLinR+/NNdtOmzBqwaO9Ld4pcCLJeOs+SSQ3/hUs5XwMNsnHjrAFa/3YxMH9DbyfZji/9Mz69xdpxmd9q43BcPNp9cKBNBv51LA5XCikUm2b0I/IEeqj22OVfVytMnMm5xK1bdJGbW6Q28YnOev3wxQ3gTIxXhJbmGeXdQZ3zTNax7HJvbmljii7IIoJOLZq+KaQ== jlode90@gmail.com"
      # jlo-zrch
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFzPHjc6wTtzHsyNGERifEt/3V69nTkcyh2gEGaNbsyD jl@zrch.com"
    ];
  };
}
