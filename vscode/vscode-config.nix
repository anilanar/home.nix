{ pkgs }: {
  userSettings = {
    "emmet.excludeLanguages" = [ "javascriptreact" "typescriptreact" ];
    "editor.suggestOnTriggerCharacters" = false;
    "editor.quickSuggestions" = false;
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
    "editor.inlineSuggest.enabled" = true;

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
    {
      key = "ctrl+shift+x";
      command = "-workbench.view.extensions";
    }
    {
      key = "ctrl+shift+x";
      command = "terminal.focus";
    }
  ];
}
