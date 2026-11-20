#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "Installing packages"
if [[ "$OSTYPE" == darwin* ]]; then
  brew install $(< packages.txt)
elif command -v dnf >/dev/null; then
  # fedora calls it vim-enhanced, and needs wl-clipboard for pbcopy/tmux copy
  sudo dnf install -y $(sed 's/^vim$/vim-enhanced/' packages.txt) wl-clipboard
fi

echo "Initializing submodules"
git submodule update --init --recursive

echo "Linking configuration"
stow zsh vim nvim git tmux

echo "Setting up nvim's python provider"
nvim_venv=~/.local/share/nvim/venv
if command -v uv >/dev/null; then
  [[ -d "$nvim_venv" ]] || uv venv -q "$nvim_venv"
  uv pip install -q --python "$nvim_venv/bin/python" pynvim jedi
else
  [[ -d "$nvim_venv" ]] || python3 -m venv "$nvim_venv"
  "$nvim_venv/bin/pip" install -q pynvim jedi
fi
nvim --headless +PlugInstall +qa

echo "Installing tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins

# Lets tmux-resurrect bring back `claude --resume <id>` in each pane, see
# tmux/.tmux/scripts/claude-pane-session.sh
claude_settings=~/.claude/settings.json
claude_hook='$HOME/.tmux/scripts/claude-pane-session.sh'
if [[ -f "$claude_settings" ]] && ! grep -qF "$claude_hook" "$claude_settings"; then
  echo "Adding tmux pane hook to Claude Code settings"
  tmp="$(mktemp)"
  jq --arg cmd "$claude_hook" \
    '.hooks.SessionStart += [{"hooks": [{"type": "command", "command": $cmd, "timeout": 3}]}]' \
    "$claude_settings" > "$tmp"
  mv "$tmp" "$claude_settings"
fi
