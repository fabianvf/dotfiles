dotfiles
========

Works on macOS (Homebrew) and Fedora.

```bash
$ ./setup.sh
```

This installs `packages.txt`, stows `zsh`, `vim`, `nvim`, `git` and `tmux` into
`$HOME`, installs the tmux plugins, and adds a Claude Code hook so restored tmux
panes resume their Claude session.

Machine-specific or secret settings go in `~/.localrc`, e.g. `PROMPT_TAG=work`
to label a machine in the prompt.

tmux
====

Prefix is `C-Space`. Sessions are saved every 15 minutes (tmux-continuum) and
restored on start (tmux-resurrect), including `nvim`, `ssh` and
`claude --resume <id>` panes. `prefix C-s` saves now, `prefix C-r` restores.

vim
===

Leader is `Space`. nvim uses the same `~/.vimrc`.

- `<space-w>` / `<space-q>`: Write / quit.
- `<space-v>`: Vertical split.
- `<C-p>`: Go to file.
- `<space-r>`: Go to symbol in file.
- `<space-f>`: Search current directory with ag or ack.
- `<space-/>`: Toggle comment.
- `<space-d>`: Toggle file browser, `<space-D>` to reveal the current file.
- `<space-h>` / `<space-l>`: Go to beginning/end of line.
- `<space-,>`: Open vimrc.
- `<space-a>`: Copy whole file.
- `<space-space-w>`: Strip trailing whitespace.
- `<space-n>`: Toggle relative line numbers.
- `<C-h|j|k|l>`: Move between vim splits and tmux panes.

### Tests (vim-test)

- `<space-tt>`: Nearest test.
- `<space-tf>`: Test file.
- `<space-ts>`: Whole suite.
- `<space-tl>`: Rerun last.

### Python (jedi)

- `<C-c>g`: Go to definition.

### Git

- `<space-gs>`: git status.
- `<space-gb>`: git blame.
- `<space-gp>`: git push.
- `<space-gB>`: Open file or selected lines on GitHub.
- `<space-gh>` / `<space-gH>`: Stage / undo hunk.
- `]h` and `[h`: Go to next/previous hunk.
