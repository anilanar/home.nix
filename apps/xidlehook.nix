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
    Install.WantedBy = [ "graphical-session.target" ];
  };

  caffeinate-lock = mkCaffeinate "lock" lock-sock;
  caffeinate-sleep = mkCaffeinate "sleep" sleep-sock;
in {
  home.packages = [ xlock xsleep caffeinate-lock caffeinate-sleep ];

  systemd.user.services.idle-lock =
    mkService "lock" lock-sock ''
      --timer 180 "${xlock}/bin/xlock" ""
    '';
  systemd.user.services.idle-sleep = mkService "sleep" sleep-sock ''
    --timer 360 "${xsleep}/bin/xsleep" ""
  '';
}
