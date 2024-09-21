{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      cal = "cal -wm";
      cp = "cp -i";
      mv = "mv -i";
      gcs = "git clone --depth 1";
      l = "eza -lagFT --git-ignore --git --level 1";
      ls = "eza";
      tb = "pkill -usr1 redshift";
      tree = "eza --tree --git-ignore";
    };
    functions = {
      # Motivation: When I use `lf` to browse the filesystem, I expect the shell
      # to change directory to where I am when I exit `lf`. This is not default
      # behavior; so this function adds that functionality.
      lfcd.body = ''
          set tmp (mktemp)
          lf -last-dir-path=$tmp $argv
          if test -f "$tmp"
            set dir (cat $tmp)
            rm -f $tmp
            if test -d "$dir"
              if test "$dir" != (pwd)
                  cd $dir
              end
            end
          end
        '';

      # Helper function to get the store path of a package
      # E.g. `nixStorePath python3`
      # Often used while debugging stuff ("what does package X actually contain?")
      nixStorePath.body = ''
        nix eval --impure --raw --expr "(import <nixpkgs> {}).$argv[1].outPath"
      '';
    };
    interactiveShellInit = ''
      bind -M insert \co 'lfcd; commandline -f repaint'
      fish_vi_key_bindings
      eval (direnv hook fish)
      if not set -q TMUX
          tmux
          kill $fish_pid
      end
      '';
  };
}
