{ pkgs, ... }:
let
  caffeinate = pkgs.rustPlatform.buildRustPackage rec {
    pname = "xidlehook-caffeinate";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "rschmukler";
      repo = "caffeinate";
      rev = version;
      sha256 = "sha256-dzAZX240XrzUpUxHxo3kxgaXo70CqBPoE++0kpzE1xQ=";
    };

    cargoHash = "sha256-G3Z3T677WwQ0ijAjeViChdfw4B2B3N1zWVVwaRSedL0=";
  };

  lock-screen-sock = "/tmp/xidlehook-lock-screen.sock";
  suspend-sock = "/tmp/xidlehook-suspend.sock";

  mkCaffeinate = name: sock:
    pkgs.writeShellScriptBin "caffeinate-${name}" ''
      exec ${caffeinate}/bin/caffeinate --socket ${lock-screen-sock} $@
    '';

  mkService = name: sock: timers: {
    Unit = {
      Description = "xidlehook service for ${name}";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
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
  };

  caffeinate-screen = mkCaffeinate "screen" lock-screen-sock;
  caffeinate-suspend = mkCaffeinate "suspend" suspend-sock;
in {
  home.packages = [ caffeinate-screen caffeinate-suspend ];

  systemd.user.services.idle-lock-screen =
    mkService "lock-screen" lock-screen-sock ''
      --timer 180 "${pkgs.xorg.xset}/bin/xset dpms force standby" "" \
      --timer 180 "${pkgs.i3lock}/bin/i3lock -n -c 000000" ""
    '';
  systemd.user.services.idle-suspend = mkService "suspend" suspend-sock ''
    --timer 360 "${pkgs.systemd}/bin/systemctl suspend" ""
  '';
}
