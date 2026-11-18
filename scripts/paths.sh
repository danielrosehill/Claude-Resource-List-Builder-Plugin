#!/usr/bin/env bash
# Resolve this plugin's user data directory (the private overlay).
#
#   scripts/paths.sh                 -> data dir, rule that picked it, profile status
#   scripts/paths.sh dir             -> only the data dir
#   scripts/paths.sh profile         -> path of the profile to read (overlay if present, else built-in defaults)
#   scripts/paths.sh template NAME   -> path of template NAME (overlay copy wins), exit 1 if none
#   scripts/paths.sh templates       -> every template: <name>\t<user|builtin>\t<path>
#
# Resolution order for the data dir (first match wins):
#   1. $RESOURCE_LIST_BUILDER_DATA
#   2. $CLAUDE_USER_DATA/resource-list-builder
#   3. ~/.claude-user-data/resource-list-builder   if ~/.claude-user-data exists
#   4. ${XDG_DATA_HOME:-~/.local/share}/claude-plugins/resource-list-builder  if that root exists
#   5. ~/.claude-user-data/resource-list-builder   default
set -euo pipefail

NAME=resource-list-builder
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
XDG_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins"

if [[ -n "${RESOURCE_LIST_BUILDER_DATA:-}" ]]; then
  DIR="$RESOURCE_LIST_BUILDER_DATA"; RULE="RESOURCE_LIST_BUILDER_DATA"
elif [[ -n "${CLAUDE_USER_DATA:-}" ]]; then
  DIR="$CLAUDE_USER_DATA/$NAME"; RULE="CLAUDE_USER_DATA"
elif [[ -d "$HOME/.claude-user-data" ]]; then
  DIR="$HOME/.claude-user-data/$NAME"; RULE="existing ~/.claude-user-data"
elif [[ -d "$XDG_ROOT" ]]; then
  DIR="$XDG_ROOT/$NAME"; RULE="existing $XDG_ROOT"
else
  DIR="$HOME/.claude-user-data/$NAME"; RULE="default"
fi

case "${1:-}" in
  dir) echo "$DIR" ;;
  profile)
    if [[ -f "$DIR/profile.yaml" ]]; then echo "$DIR/profile.yaml"; else echo "$PLUGIN_ROOT/defaults/profile.yaml"; fi ;;
  template)
    n="${2:?template name}"
    if [[ -f "$DIR/templates/$n" ]]; then echo "$DIR/templates/$n"
    elif [[ -f "$PLUGIN_ROOT/templates/$n" ]]; then echo "$PLUGIN_ROOT/templates/$n"
    else echo "no template named '$n'" >&2; exit 1; fi ;;
  templates)
    declare -A seen=()
    if [[ -d "$DIR/templates" ]]; then
      for f in "$DIR/templates"/*; do [[ -f "$f" ]] || continue; b=$(basename "$f"); seen[$b]=1; printf '%s\tuser\t%s\n' "$b" "$f"; done
    fi
    for f in "$PLUGIN_ROOT/templates"/*; do [[ -f "$f" ]] || continue; b=$(basename "$f"); [[ -n "${seen[$b]:-}" ]] || printf '%s\tbuiltin\t%s\n' "$b" "$f"; done ;;
  "")
    echo "data_dir: $DIR"; echo "rule: $RULE"; echo "plugin_root: $PLUGIN_ROOT"
    echo "profile: $([[ -f "$DIR/profile.yaml" ]] && echo present || echo "missing (built-in defaults apply; run setup)")" ;;
  *) echo "usage: $0 [dir|profile|template NAME|templates]" >&2; exit 2 ;;
esac
