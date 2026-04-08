{ pkgs, unstable, ... }:

let
  # Nixpkgs ships tree-sitter 0.25.10, but nvim-treesitter requires
  # tree-sitter-cli >= 0.26.1. Use the upstream prebuilt binary until
  # nixpkgs catches up.
  tree-sitter-bin = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "tree-sitter-bin";
    version = "0.26.1";

    src =
      if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then
        pkgs.fetchurl {
          url = "https://github.com/tree-sitter/tree-sitter/releases/download/v${version}/tree-sitter-macos-arm64.gz";
          hash = "sha256-gjJU6sKp0AbtA6dBgSZSSc2vWXsXvYCK3GNhDER7sL8=";
        }
      else if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
        pkgs.fetchurl {
          url = "https://github.com/tree-sitter/tree-sitter/releases/download/v${version}/tree-sitter-linux-x64.gz";
          hash = "sha256-10GC//v0QfJHNxrWr3fZmxCsn3iNfgaOS0SZLZ1tfCY=";
        }
      else
        throw "tree-sitter-bin: unsupported platform ${pkgs.stdenv.hostPlatform.system}";

    dontUnpack = true;

    nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      pkgs.autoPatchelfHook
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      gunzip -c $src > $out/bin/tree-sitter
      chmod +x $out/bin/tree-sitter
      runHook postInstall
    '';

    meta = {
      description = "Tree-sitter CLI (upstream prebuilt binary)";
      mainProgram = "tree-sitter";
    };
  };
in
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
      tree-sitter-bin
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
