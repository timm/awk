#!/usr/bin/env bash
# install.sh -- symlink the after/ tree into ~/.config/nvim/after/.
# Idempotent: removes stale symlinks first.

set -e
SRC=$(cd "$(dirname "$0")" && pwd)
DST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/after"

mkdir -p "$DST/syntax" "$DST/ftplugin"

for sub in syntax/awk.vim ftplugin/awk.vim; do
  src="$SRC/after/$sub"
  dst="$DST/$sub"
  [ -L "$dst" ] && rm "$dst"
  [ -e "$dst" ] && { echo "skip (exists, not a symlink): $dst" >&2; continue; }
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
done
