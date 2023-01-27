args@{ pkgs, system }:
let
  node18-overlay = final: prev: { nodejs = prev.nodejs-18_x; };
  cypress-latest = import ./cypress.nix pkgs;
  pkgs = args.pkgs.extend node18-overlay;
  exts = import ../vscode/vscode-extensions.nix { inherit pkgs; };
  config = import ../vscode/vscode-config.nix { inherit pkgs; };
  turbo = pkgs.callPackage ./turbo.nix pkgs;
  mkVscode = { extraExts }:
    let
      settings = pkgs.writeText "vscode-user-settings"
        (builtins.toJSON config.userSettings);
      keybindings = pkgs.writeText "vscode-user-keybindings"
        (builtins.toJSON config.keybindings);

      vscode = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = (with exts; [ nix nixfmt vim gitlens github ])
          ++ extraExts;
      };
    in pkgs.writeScriptBin "code" ''
      hash=$(nix hash path --base32 ${vscode})
      tmpdir=$(dirname $(mktemp -u))/$(whoami)/$hash
      mkdir -p $tmpdir/User
      ln -sfn ${settings} $tmpdir/User/settings.json
      ln -sfn ${keybindings} $tmpdir/User/keybindings.json

      exec "${vscode}/bin/codium" --user-data-dir $tmpdir "$@"
    '';
  mkShell = { extraInputs ? [ ], extraExts ? [ ], extraEnv ? { } }:
    pkgs.mkShell ({
      buildInputs = with pkgs;
        [ nixfmt (mkVscode { inherit extraExts; }) ] ++ extraInputs;
    } // extraEnv);
in {
  inherit mkShell;
  inherit mkVscode;
  inherit exts;

  nix = mkShell { };

  gherkin = mkShell { extraExts = with exts; [ gherkin ]; };

  js = mkShell {
    extraInputs = with pkgs;
      [
      nodejs-18_x
      nodePackages.pnpm
      nodePackages.yarn
      automake
      autoconf
      watchman
      ] ++ (if system == "x86_64-linux" then [ cypress-latest ] else [ ]);

    extraExts = (with exts; [
      eslint
      stylelint
      editorConfig
      gitlens
      prettier
      jest
      zipfs
      tailwind
      yaml
      docker
      prisma
    ]);
    extraEnv = {
      shellHook = if system == "x86_64-linux" then ''
        export CYPRESS_RUN_BINARY="${cypress-latest}/bin/Cypress"
        export TURBO_BINARY_PATH="${turbo}/bin/turbo"
      '' else
        "";
    };
  };

  haskell = mkShell {
    extraInputs = with pkgs; [
      stack
      haskell-language-server
      haskellPackages.ghcide
      haskellPackages.implicit-hie
    ];
    extraExts = with exts; [ haskell language-haskell ];
  };

  rust = { extraInputs ? [ ], extraExts ? [ ], extraEnv ? { } }:
    mkShell {
      extraInputs = with pkgs; [ rustc cargo rustfmt openssl rustup ] ++ extraInputs;

      extraExts = with exts; [ rust ] ++ extraExts;

      extraEnv = {
        OPENSSL_DIR = "${pkgs.openssl.dev}";
        OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      } // extraEnv;
    };

}
