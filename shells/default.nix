{ pkgs }:
let
  exts = pkgs.callPackage ./vscode-extensions.nix { inherit pkgs; };
  set = pkgs.callPackage ./vscode-settings.nix { inherit pkgs; };
  mkVscode = { extraExts }:
    let
      userDir = pkgs.linkFarm "vscode-user-dir" [
        {
          name = "settings.json";
          path = pkgs.writeText "vscode-user-settings" (builtins.toJSON set.userSettings);
        }
        {
          name = "keybindings.json";
          path = pkgs.writeText "vscode-user-keybindings" (builtins.toJSON set.keybindings);
        }
      ];
      vscode = pkgs.vscode-with-extensions.override {
        vscodeExtensions = (with exts; [ vim copilot gitlens ]) ++ extraExts;
      };
    in pkgs.writeScriptBin "code" ''
      #!${pkgs.stdenv.shell}
      ${pkgs.vscode}/bin/code --user-data-dir ${userDir} .
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
