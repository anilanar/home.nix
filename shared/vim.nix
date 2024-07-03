{ pkgs, ... }:

let
  vimConfig = ''
    set viminfo+=n~/.vim/viminfo 
    set clipboard=unnamed,unnamedplus,autoselect
  '';

in {
  programs.vim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.fzf-vim ];
    extraConfig = vimConfig;
    defaultEditor = true;
  };
}
