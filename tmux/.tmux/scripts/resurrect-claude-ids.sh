#!/usr/bin/env bash
# tmux-resurrect post-save-layout hook: rewrite saved `claude` commands to
# `claude --resume <id>` using the ids recorded by claude-pane-session.sh.
file="$1"
dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/claude-panes"
[ -f "$file" ] && [ -d "$dir" ] || exit 0

map="$(mktemp)"
tmux list-panes -a -F '#{session_name}	#{window_index}	#{pane_index}	#{pane_id}' |
	while IFS=$'\t' read -r s w p id; do
		f="$dir/${id#%}"
		[ -s "$f" ] && printf '%s\t%s\t%s\t%s\n' "$s" "$w" "$p" "$(cat "$f")"
	done > "$map"

awk -F'\t' -v OFS='\t' '
	NR == FNR { ids[$1 FS $2 FS $3] = $4; next }
	$1 == "pane" && $10 == "claude" && (($2 FS $3 FS $6) in ids) {
		n = split(substr($11, 2), a, " "); cmd = a[1]
		for (i = 2; i <= n; i++) {
			if (a[i] == "--continue" || a[i] == "-c") continue
			if (a[i] == "--resume" || a[i] == "-r") {
				if (i < n && a[i+1] !~ /^-/) i++
				continue
			}
			cmd = cmd " " a[i]
		}
		$11 = ":" cmd " --resume " ids[$2 FS $3 FS $6]
	}
	{ print }
' "$map" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
rm -f "$map"
