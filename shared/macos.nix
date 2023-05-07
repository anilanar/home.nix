{ pkgs, config, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh = {
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  home.file.".1password/agent.sock".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  home.file.".1password/op-ssh-sign".source = 
    config.lib.file.mkOutOfStoreSymlink "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  xdg = { enable = true; };
}
