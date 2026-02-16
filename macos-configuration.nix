{ pkgs, config, lib, ... }:
{
  nix.settings = {
    trusted-users = [
      "root"
      "aanar"
    ];
    trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
    substituters = [ "https://devenv.cachix.org" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
    min-free = ${toString (1 * 1024 * 1024 * 1024)}
    max-free = ${toString (5 * 1024 * 1024 * 1024)}
  '';
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

  system.primaryUser = "aanar";

  environment.systemPackages = [ ];

  fonts = {
    packages = [
      pkgs.jetbrains-mono
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.keyboard.fnState" = true;
    };
    dock.autohide = true;
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      FXEnableExtensionChangeWarning = false;
    };
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
    CustomUserPreferences = {
      "com.apple.coreservices.useractivityd" = {
        ClipboardSharingEnabled = 1;
      };
      "com.microsoft.VSCode" = {
        "ApplePressAndHoldEnabled" = false;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  programs.zsh.enable = true;

  # system.activationScripts.postUserActivation.text = ''
  #   rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
  #   apps_source="${config.system.build.applications}/Applications"
  #   moniker="Nix Trampolines"
  #   app_target_base="$HOME/Applications"
  #   app_target="$app_target_base/$moniker"
  #   mkdir -p "$app_target"
  #   ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
  # '';

  system.stateVersion = 5;
}
