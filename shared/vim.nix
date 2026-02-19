{ pkgs, unstable, ... }:

let
  vimConfig = ''
    set viminfo+=n~/.vim/viminfo
    set clipboard=${if pkgs.stdenv.isDarwin then "unnamed" else "unnamed,unnamedplus,autoselect"}
  '';

in
{
  programs.vim = {
    enable = true;
    packageConfigurable = unstable.vim-full.override {
      darwinSupport = true;
      guiSupport = false;
    };
    plugins = [ unstable.vimPlugins.fzf-vim ];
    extraConfig = vimConfig;
    defaultEditor = true;
  };
}
