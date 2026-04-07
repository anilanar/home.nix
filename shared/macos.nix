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

  programs.zsh.initContent = ''
    # --- cmux workspace setup ---
    ws() {
      local name="''${1:-default}"
      local dir="''${2:-$(pwd)}"
      dir=$(cd "$dir" && pwd)
      local sock="/tmp/nvim-''${name}.sock"

      cmux workspace new "$name"
      cmux send "cd $dir && export NVIM_SOCK=$sock && nv $name"
      cmux send-key enter
      cmux split right
      cmux send "cd $dir && export NVIM_SOCK=$sock"
      cmux send-key enter
    }
  '';

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

  # Claude Code status line — worktrunk data with custom styling.
  home.file.".claude/statusline-command.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      input=$(cat)

      cwd=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir // .cwd // empty')
      model=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // empty')
      used_pct=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.used_percentage // empty')

      # Get worktrunk data
      wt_json=$(${unstable.worktrunk}/bin/wt list statusline --format=json -C "$cwd" 2>/dev/null)
      branch=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].branch // empty')
      symbols=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].symbols // empty')
      main_ahead=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].main.ahead // 0')
      main_behind=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].main.behind // 0')
      diff_added=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].main.diff.added // 0')
      diff_deleted=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].main.diff.deleted // 0')
      is_worktree=$(echo "$wt_json" | ${pkgs.jq}/bin/jq -r '.[0].kind == "worktree"')

      # Directory display
      dir_display=""
      if ${pkgs.git}/bin/git -C "$cwd" rev-parse --show-toplevel > /dev/null 2>&1; then
        repo_toplevel=$(${pkgs.git}/bin/git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
        if [ "$is_worktree" = "true" ]; then
          git_common_dir=$(${pkgs.git}/bin/git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)
          repo_name=$(basename "$(dirname "$git_common_dir")")
        else
          repo_name=$(basename "$repo_toplevel")
        fi
        rel_path="''${cwd#"$repo_toplevel"}"
        rel_path="''${rel_path#/}"
        if [ -n "$rel_path" ]; then
          dir_display="$repo_name - $rel_path"
        else
          dir_display="$repo_name"
        fi
      else
        dir_display=$(basename "$cwd")
      fi

      # Worktree indicator
      wt_icon=""
      [ "$is_worktree" = "true" ] && wt_icon=" 🌳"

      # Branch
      branch_info=""
      [ -n "$branch" ] && branch_info=" on \033[1;35m$branch\033[0m"

      # Git stats from worktrunk
      git_stats=""
      if [ "$main_ahead" -gt 0 ] || [ "$main_behind" -gt 0 ]; then
        stats=""
        [ "$main_ahead" -gt 0 ] && stats="↑$main_ahead"
        [ "$main_behind" -gt 0 ] && stats="''${stats:+$stats }↓$main_behind"
        [ "$diff_added" -gt 0 ] && stats="$stats \033[32m+$diff_added\033[0m"
        [ "$diff_deleted" -gt 0 ] && stats="$stats \033[31m-$diff_deleted\033[0m"
        git_stats=" \033[2m[$stats\033[0m\033[2m]\033[0m"
      fi

      # Session marker from worktrunk symbols
      marker=""
      if echo "$symbols" | grep -q "🤖"; then
        marker=" 🤖"
      elif echo "$symbols" | grep -q "💬"; then
        marker=" 💬"
      fi

      # Context usage
      ctx_info=""
      if [ -n "$used_pct" ]; then
        ctx_size=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.context_window.context_window_size // 1000000')
        compact_buf=33000
        used_int=$(${pkgs.gawk}/bin/awk "BEGIN { printf \"%d\", $used_pct + $compact_buf * 100 / $ctx_size }")
        if [ "$used_int" -ge 75 ]; then
          ctx_info=" \033[31m[ctx: ''${used_int}%]\033[0m"
        elif [ "$used_int" -ge 40 ]; then
          ctx_info=" \033[33m[ctx: ''${used_int}%]\033[0m"
        else
          ctx_info=" \033[32m[ctx: ''${used_int}%]\033[0m"
        fi
      fi

      # Model
      model_info=""
      [ -n "$model" ] && model_info=" \033[1;36m$model\033[0m"

      printf "\033[1;34m%b\033[0m%b%b%b%b%b%b" "$dir_display" "$wt_icon" "$branch_info" "$marker" "$git_stats" "$model_info" "$ctx_info"
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
