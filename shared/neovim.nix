{ pkgs, unstable, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    package = unstable.neovim-unwrapped;

    extraPackages = with pkgs; [
      ripgrep
      fd
      lua-language-server
      vtsls
      vscode-langservers-extracted
      nil
    ];
  };

  home.packages = with pkgs; [
    neovim-remote
    lazygit
  ];
}
