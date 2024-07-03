{ pkgs, config, lib, ... }:

{
  imports = [ ./common.nix ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.xdg.configHome}/1password/agent.sock";
  };

  home.file.".config/1password/agent.sock".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  home.file.".config/1password/op-ssh-sign".source = 
    config.lib.file.mkOutOfStoreSymlink "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  xdg = { enable = true; };
  
  programs.zellij = {
    settings = {
      copy_command = "pbcopy";
    };
  };

  home.activation = {
    rsync-home-manager-applications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
      apps_source="$genProfilePath/home-path/Applications"
      moniker="Home Manager Trampolines"
      app_target_base="${config.home.homeDirectory}/Applications"
      app_target="$app_target_base/$moniker"
      mkdir -p "$app_target"
      ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
    '';
  };
}
