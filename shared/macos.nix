{
  pkgs,
  unstable,
  config,
  lib,
  ...
}:

{
  imports = [ ./common.nix ];

  home.packages = [
    unstable._1password-cli
  ];

  home.sessionVariables = {
    SSH_AUTH_SOCK = "${config.xdg.configHome}/1password/agent.sock";
  };

  home.file.".config/1password/agent.sock".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  home.file.".config/1password/op-ssh-sign".source =
    config.lib.file.mkOutOfStoreSymlink "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  xdg = {
    enable = true;
  };

  programs.zellij = {
    settings = {
      copy_command = "pbcopy";
    };
  };

  # Claude Code settings and hooks managed by Home Manager.
  home.activation.claudeSettings =
    let
      managedSettings = builtins.toJSON {
        statusLine = {
          type = "command";
          command = "bash ~/.claude/statusline-command.sh";
        };
        hooks = { };
      };
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings_file="$HOME/.claude/settings.json"
      managed='${managedSettings}'
      mkdir -p "$(dirname "$settings_file")"
      if [ -L "$settings_file" ]; then
        existing=$(cat "$settings_file")
        rm "$settings_file"
        echo "$existing" | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' - <(echo "$managed") > "$settings_file"
      elif [ -f "$settings_file" ]; then
        ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$settings_file" <(echo "$managed") > "$settings_file.tmp"
        mv "$settings_file.tmp" "$settings_file"
      else
        echo "$managed" | ${pkgs.jq}/bin/jq . > "$settings_file"
      fi
    '';


  # Claude Code status line — mirrors default Starship prompt style.
  home.file.".claude/statusline-command.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      input=$(cat)

      cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
      model=$(echo "$input" | jq -r '.model.display_name // empty')
      used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

      # Detect git repo, worktree, and branch
      worktree_indicator=""
      dir_display=""
      git_branch=""
      if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
        git_dir=$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)
        git_common_dir=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)
        repo_toplevel=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)

        # Branch
        branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
          git_branch=" on \033[35m$branch\033[0m"
        fi

        # Worktree detection: git-dir differs from git-common-dir
        is_worktree=false
        if [ "$git_dir" != "$git_common_dir" ]; then
          is_worktree=true
          worktree_indicator=" 🌳"
          # Main repo root is parent of .git/worktrees dir
          main_repo_root=$(dirname "$git_common_dir")
          repo_name=$(basename "$main_repo_root")
        else
          repo_name=$(basename "$repo_toplevel")
        fi

        # Relative path from repo root (worktree root for worktrees)
        rel_path="''${cwd#"$repo_toplevel"}"
        rel_path="''${rel_path#/}"

        if [ -n "$rel_path" ]; then
          dir_display="$repo_name - $rel_path"
        else
          dir_display="$repo_name"
        fi
      else
        # Not a git repo — just show basename of cwd
        dir_display=$(basename "$cwd")
      fi

      # Context usage indicator (percentage of usable window, excluding 33k autocompact buffer)
      ctx_info=""
      if [ -n "$used_pct" ]; then
        ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 1000000')
        compact_buf=33000
        used_int=$(awk "BEGIN { printf \"%d\", $used_pct + $compact_buf * 100 / $ctx_size }")
        if [ "$used_int" -ge 75 ]; then
          ctx_info=" \033[31m[ctx: ''${used_int}%]\033[0m"
        elif [ "$used_int" -ge 40 ]; then
          ctx_info=" \033[33m[ctx: ''${used_int}%]\033[0m"
        else
          ctx_info=" \033[32m[ctx: ''${used_int}%]\033[0m"
        fi
      fi

      # Model display
      model_info=""
      if [ -n "$model" ]; then
        model_info=" \033[36m$model\033[0m"
      fi

      printf "\033[1;34m%b\033[0m%b%b%b%b" "$dir_display" "$worktree_indicator" "$git_branch" "$model_info" "$ctx_info"
    '';
  };


  # home.activation = {
  #   rsync-home-manager-applications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
  #     apps_source="$genProfilePath/home-path/Applications"
  #     moniker="Home Manager Trampolines"
  #     app_target_base="${config.home.homeDirectory}/Applications"
  #     app_target="$app_target_base/$moniker"
  #     mkdir -p "$app_target"
  #     ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
  #   '';
  # };
}
