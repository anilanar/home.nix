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
        vscodeExtensions = (with exts; [ vim copilot gitlens ]) ++ extraExts;
      };
    in pkgs.writeScriptBin "code" ''
      hash=$(nix hash path --base32 ${vscode})
      tmpdir=$(${pkgs.mktemp}/bin/mktemp -d --suffix $hash)
      mkdir -p $tmpdir/User
      ln -s ${settings} $tmpdir/User/settings.json
      ln -s ${keybindings} $tmpdir/User/keybindings.json

      exec "${vscode}/bin/code" --user-data-dir $tmpdir "$@"
    '';
in {
  js = pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs
      yarn
      (mkVscode {
        extraExts =
          (with exts; [ eslint stylelint editorConfig gitlens prettier ]);
      })
    ];
  };

  nix = pkgs.mkShell {
    buildInputs = with pkgs; [
      nixfmt
      (mkVscode { extraExts = (with exts; [ nix nixfmt ]); })
    ];
  };

  haskell = pkgs.mkShell {
    buildInputs = with pkgs; [
      stack
      haskell-language-server
      haskellPackages.ghcide
      haskellPackages.implicit-hie
      (mkVscode { extraExts = (with exts; [ haskell language-haskell ]); })
    ];
  };
}
