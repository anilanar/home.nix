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

  home.file.".config/1password/agent.sock".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  home.file.".config/1password/op-ssh-sign".source = config.lib.file.mkOutOfStoreSymlink "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  xdg = {
    enable = true;
  };

  programs.zellij = {
    settings = {
      copy_command = "pbcopy";
    };
  };

  # Claude Code hooks for macOS notifications with click-to-focus.
  # Uses terminal-notifier for notifications and Hammerspoon to focus the
  # exact terminal window (across Spaces) when the notification is clicked.
  # Requires: Hammerspoon.app in /Applications with Accessibility permissions.

  home.file.".claude/settings.json".text = builtins.toJSON {
    hooks = {
      SessionStart = [{
        matcher = "";
        hooks = [{
          type = "command";
          command = "bash ~/.claude/session-start-hook.sh";
          timeout = 10;
        }];
      }];
      Notification = [{
        matcher = "";
        hooks = [{
          type = "command";
          command = "bash ~/.claude/notify-hook.sh";
          timeout = 30;
        }];
      }];
      UserPromptSubmit = [{
        matcher = "";
        hooks = [{
          type = "command";
          command = "$HOME/.claude/hooks/prevent-sleep.sh";
        }];
      }];
      Stop = [{
        matcher = "";
        hooks = [
          {
            type = "command";
            command = "bash ~/.claude/stop-hook.sh";
            timeout = 30;
          }
          {
            type = "command";
            command = "$HOME/.claude/hooks/allow-sleep.sh";
          }
        ];
      }];
    };
  };

  # Captures the focused window ID at session start so we can restore it later.
  home.file.".claude/session-start-hook.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      INPUT=$(cat)
      SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
      HS=/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs
      WINDOW_ID=$($HS -c "local w=hs.window.focusedWindow(); print(w and w:id() or 'ERROR')" 2>/dev/null)

      if [ "$WINDOW_ID" != "ERROR" ] && [ -n "$WINDOW_ID" ]; then
        mkdir -p /tmp/cc-notifier
        echo "$WINDOW_ID" > "/tmp/cc-notifier/$SESSION_ID"
      fi
    '';
  };

  # Notifies when Claude needs input (permission prompts, etc.).
  home.file.".claude/notify-hook.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      INPUT=$(cat)
      TITLE=$(echo "$INPUT" | jq -r '.title // "Claude Code"')
      MSG=$(echo "$INPUT" | jq -r '.message // "Needs your attention"')
      SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
      WINDOW_ID=$(cat "/tmp/cc-notifier/$SESSION_ID" 2>/dev/null)
      HS=/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs

      FOCUS_CMD="$HS -c \"local current = require('hs.window.filter').new():setCurrentSpace(true):getWindows(); local other = require('hs.window.filter').new():setCurrentSpace(false):getWindows(); for _,w in pairs(other) do table.insert(current, w) end; for _,w in pairs(current) do if w:id()==''${WINDOW_ID:-0} then w:focus(); require('hs.timer').usleep(300000); return end end\""

      nix run nixpkgs#terminal-notifier -- -title "$TITLE" -message "$MSG" -execute "$FOCUS_CMD" &
      exit 0
    '';
  };

  # Notifies when Claude finishes responding.
  home.file.".claude/stop-hook.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      INPUT=$(cat)
      ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
      if [ "$ACTIVE" = "true" ]; then exit 0; fi
      SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
      WINDOW_ID=$(cat "/tmp/cc-notifier/$SESSION_ID" 2>/dev/null)
      HS=/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs

      FOCUS_CMD="$HS -c \"local current = require('hs.window.filter').new():setCurrentSpace(true):getWindows(); local other = require('hs.window.filter').new():setCurrentSpace(false):getWindows(); for _,w in pairs(other) do table.insert(current, w) end; for _,w in pairs(current) do if w:id()==''${WINDOW_ID:-0} then w:focus(); require('hs.timer').usleep(300000); return end end\""

      nix run nixpkgs#terminal-notifier -- -title "Claude Code" -message "Claude has finished responding" -execute "$FOCUS_CMD" &
      exit 0
    '';
  };

  # Prevents Mac from sleeping while Claude Code is working (caffeinate -i for up to 1 hour).
  home.file.".claude/hooks/prevent-sleep.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      if [ -f /tmp/claude_caffeinate.pid ]; then
        old_pid=$(cat /tmp/claude_caffeinate.pid)
        if ps -p "$old_pid" > /dev/null 2>&1; then
          if ps -p "$old_pid" -o args= | grep -q '^caffeinate'; then
            kill "$old_pid" 2>/dev/null
          fi
        fi
        rm -f /tmp/claude_caffeinate.pid
      fi
      nohup caffeinate -i -t 3600 > /dev/null 2>&1 &
      echo $! > /tmp/claude_caffeinate.pid
    '';
  };

  # Restores normal sleep behavior when Claude stops.
  home.file.".claude/hooks/allow-sleep.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      if [ -f /tmp/claude_caffeinate.pid ]; then
        kill $(cat /tmp/claude_caffeinate.pid) 2>/dev/null
        rm /tmp/claude_caffeinate.pid
      fi
    '';
  };

  # Hammerspoon config: loads IPC (for hs CLI) and window modules (for focusing).
  home.file.".hammerspoon/init.lua".text = ''
    require("hs.ipc")
    require("hs.window")
    require("hs.window.filter")
    require("hs.timer")
  '';

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
