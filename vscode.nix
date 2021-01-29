{ pkgs, ... }:
let
  extensions = (with pkgs.vscode-extensions;
    [ bbenoist.Nix vscodevim.vim ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "nixfmt-vscode";
        publisher = "brettm12345";
        version = "0.0.1";
        sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
      }
      {
        name = "editorconfig";
        publisher = "editorconfig";
        version = "0.14.5";
        sha256 = "1bp6x5ha6vz0y7yyk4xsylp7d4z8qv20ybfbr3qqajnf61rzdbkg";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "10.2.1";
        sha256 = "1bh6ws20yi757b4im5aa6zcjmsgdqxvr1rg86kfa638cd5ad1f97";

      }
      {
        name = "prettier-vscode";
        publisher = "esbenp";
        version = "4.4.0";
        sha256 = "16iaz8y0cihqlkiwgxgvcyzick8m3xwqsa3pzjdcx5qhx73pykby";
      }
    ]);
in {
  home.packages = [ (import ./update-vscode-exts { inherit pkgs; }) ];
  programs.vscode = {
    inherit extensions;

    enable = true;
    userSettings = {
      "update.mode" = "none";
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "terminal.external.linuxExec" = pkgs.zsh;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.cursorBlinking" = true;
      "vim.useSystemClipboard" = true;
      "vim.handleKeys" = {
        "<C-k>" = false;
        "<C-b>" = false;
        "<C-f>" = false;
      };
      "window.zoomLevel" = -1;
      "workbench.tree.indent" = 20;
      "editor.autoClosingBrackets" = "never";
      "workbench.editor.enablePreview" = false;
      "codestream.email" = "anilanar@hotmail.com";
      "tsautoreturntype.inferArrowFunctionReturnType" = true;

      "[nix]" = { "editor.defaultFormatter" = "brettm12345.nixfmt-vscode"; };
    };
    keybindings = [
      {
        key = "ctrl+shift+d";
        command = "-workbench.view.debug";
      }
      {
        key = "ctrl+shift+d";
        command = "references-view.find";
        when = "editorHasReferenceProvider";
      }
      {
        key = "shift+alt+f12";
        command = "-references-view.find";
        when = "editorHasReferenceProvider";
      }
    ];
  };
}
