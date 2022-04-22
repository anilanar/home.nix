{ pkgs }:
let
  exts = import ../vscode/vscode-extensions.nix { inherit pkgs; };
  config = import ../vscode/vscode-config.nix { inherit pkgs; };
  mkVscode = { extraExts }:
    let
      settings = pkgs.writeText "vscode-user-settings"
        (builtins.toJSON config.userSettings);
      keybindings = pkgs.writeText "vscode-user-keybindings"
        (builtins.toJSON config.keybindings);

      vscode = pkgs.vscode-with-extensions.override {
        vscodeExtensions = (with exts; [ nix nixfmt vim copilot gitlens github ])
          ++ extraExts;
      };
    in pkgs.writeScriptBin "code" ''
      hash=$(nix hash path --base32 ${vscode})
      tmpdir=/tmp/$hash
      mkdir -p $tmpdir/User
      ln -sfn ${settings} $tmpdir/User/settings.json
      ln -sfn ${keybindings} $tmpdir/User/keybindings.json

      exec "${vscode}/bin/code" --user-data-dir $tmpdir "$@"
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

  js = mkShell {
    extraInputs = with pkgs; [
      nodejs-12_x
      python38
      automake
      autoconf
      yarn
      watchman
    ];
    extraExts = (with exts; [
      eslint
      stylelint
      editorConfig
      gitlens
      prettier
      jest
      svelte
    ]);
    extraEnv = {
      shellHook = ''
        export PATH="$PATH:$(yarn global bin)"
      '';
    };
  };

  nix = mkShell { };

  gherkin = mkShell { extraExts = with exts; [ gherkin ]; };

  js2 = mkShell {
    extraInputs = with pkgs; [ nodejs-16_x automake autoconf yarn watchman ];
    extraExts = (with exts; [
      eslint
      stylelint
      editorConfig
      gitlens
      prettier
      jest
      zipfs
      tailwind
      k8s
      bridge-to-k8s
      yaml
    ]);
    # shellHook doesn't work with direnv,
    # see https://github.com/nix-community/nix-direnv/issues/109
    extraEnv = {
      # shellHook = ''
      #   export PATH="$PATH:$(yarn global bin)"
      # '';
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
      extraInputs = with pkgs; [ rustc cargo rustfmt openssl ] ++ extraInputs;

      extraExts = with exts; [ rust ] ++ extraExts;

      extraEnv = {
        OPENSSL_DIR = "${pkgs.openssl.dev}";
        OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      } // extraEnv;
    };
  
}
