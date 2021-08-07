{ pkgs }:
let
  exts = pkgs.callPackage ./vscode-extensions.nix { inherit pkgs; };
  mkVscode = { extraExts }:
    pkgs.vscode-with-extensions.override {
      vscodeExtensions = (with exts; [ vim copilot gitlens ]) ++ extraExts;
    };
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
