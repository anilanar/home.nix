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

  home.sessionVariables = {
    VISUAL = "${pkgs.vim}/bin/vim";
    EDITOR = "${pkgs.vim}/bin/vim";
  };

}
