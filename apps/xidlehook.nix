{ pkgs, ... }:
let
  caffeinate = pkgs.rustPlatform.buildRustPackage rec {
    pname = "xidlehook-caffeinate";
    version = "0.2.0-pre";

    src = pkgs.fetchFromGitHub {
      owner = "rschmukler";
      repo = "caffeinate";
      rev = "e20985a4b630eb5c76e16c2547da0aba65f097d5";
      sha256 = "sha256-22gQ+rXANrCgaqtji3BAA0ITmEoVua+q4C+KEn5LM90=";
    };

    cargoHash = "sha256-xCsO3vB15ZVeJ3BylhOEOsOV7oKnJGSIrC/db/xN2z0=";
  };

  lock-sock = "/tmp/xidlehook-lock.sock";
  sleep-sock = "/tmp/xidlehook-sleep.sock";

  xlock = pkgs.writeShellScriptBin "xlock" ''
    ${pkgs.xorg.xset}/bin/xset dpms force standby
    ${pkgs.i3lock}/bin/i3lock -n -c 000000
  '';

  xsleep = pkgs.writeShellScriptBin "xsleep" ''
    ${pkgs.systemd}/bin/systemctl suspend
  '';

  mkCaffeinate = name: sock:
    pkgs.writeShellScriptBin "caffeinate-${name}" ''
      exec ${caffeinate}/bin/caffeinate --socket ${sock} $@
    '';

  mkService = name: sock: timers: {
    Unit = {
      Description = "xidlehook service for ${name}";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session-pre.target" ];
      ConditionEnvironment = [ "DISPLAY" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "idle-${name}" ''
        ${pkgs.xidlehook}/bin/xidlehook --socket ${sock} \
          --detect-sleep --not-when-fullscreen --not-when-audio \
          ${timers}
      ''}";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  caffeinate-lock = mkCaffeinate "lock" lock-sock;
  caffeinate-sleep = mkCaffeinate "sleep" sleep-sock;
in {
  home.packages = [ xlock xsleep caffeinate-lock caffeinate-sleep ];

  systemd.user.services.idle-lock =
    mkService "lock" lock-sock ''
      --timer 300 "${xlock}/bin/xlock" ""
    '';
  systemd.user.services.idle-sleep = mkService "sleep" sleep-sock ''
    --timer 600 "${xsleep}/bin/xsleep" ""
  '';
}
