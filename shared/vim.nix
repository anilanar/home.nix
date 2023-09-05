{ pkgs, ... }:

let
  vimConfig = ''
    set clipboard=unnamed,unnamedplus,autoselect
  '';

in {
  programs.vim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.fzf-vim ];
    extraConfig = vimConfig;
  };
}
