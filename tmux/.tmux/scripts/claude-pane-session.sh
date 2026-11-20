#!/usr/bin/env bash
# Claude Code SessionStart hook: remember which Claude session is running in
# which tmux pane, so resurrect can restore it with `claude --resume <id>`.
[ -n "$TMUX_PANE" ] || exit 0
id="$(sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
[ -n "$id" ] || exit 0
dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/claude-panes"
mkdir -p "$dir"
echo "$id" > "$dir/${TMUX_PANE#%}"
