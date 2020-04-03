{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      cp = "cp -i";
      l = "exa -lagFT --git-ignore --git --level 1";
      ls = "exa -a --git-ignore";
      mv = "mv -i";
      tree = "exa --tree --git-ignore";
    };
    functions = {
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
          end
        '';
    };
    interactiveShellInit = ''
      bind -M insert \co 'lfcd; commandline -f repaint'
      fish_vi_key_bindings
      '';
  };
}
