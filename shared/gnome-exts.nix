{ pkgs, lib, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      { package = vitals; }
      { package = auto-move-windows; }
      { package = keep-awake; }
    ];
  };
}
