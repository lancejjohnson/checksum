#!/bin/sh
# Install the checksum plugin into local Claude Code and/or Codex.
#
# Usage:
#   scripts/install-local.sh [--claude] [--codex] [--copy] [--uninstall]
#
# With no host flag, installs to every host whose CLI/home is present.
#   --copy       Codex: copy skill dirs instead of symlinking (symlink keeps
#                the install live-updating as you edit this repo)
#   --uninstall  Remove what this script installed
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CODEX_SKILLS="$CODEX_HOME/skills"

do_claude=false
do_codex=false
mode=install
codex_link=true

for arg in "$@"; do
  case "$arg" in
    --claude) do_claude=true ;;
    --codex) do_codex=true ;;
    --copy) codex_link=false ;;
    --uninstall) mode=uninstall ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# Default: target whatever is present on this machine.
if ! $do_claude && ! $do_codex; then
  command -v claude >/dev/null 2>&1 && do_claude=true
  [ -d "$CODEX_HOME" ] && do_codex=true
  if ! $do_claude && ! $do_codex; then
    echo "Neither the claude CLI nor $CODEX_HOME found. Nothing to do." >&2
    exit 1
  fi
fi

claude_install() {
  if ! command -v claude >/dev/null 2>&1; then
    cat >&2 <<EOF
claude CLI not found. Install manually inside Claude Code:
  /plugin marketplace add $ROOT
  /plugin install checksum@checksum
EOF
    return 1
  fi
  # Registering an already-known marketplace fails; refresh it instead.
  claude plugin marketplace add "$ROOT" 2>/dev/null \
    || claude plugin marketplace update checksum
  claude plugin install checksum@checksum
  echo "claude: installed checksum@checksum (marketplace: $ROOT)"
}

claude_uninstall() {
  command -v claude >/dev/null 2>&1 || { echo "claude CLI not found" >&2; return 1; }
  claude plugin uninstall checksum@checksum || true
  claude plugin marketplace remove checksum || true
  echo "claude: uninstalled"
}

codex_install() {
  mkdir -p "$CODEX_SKILLS"
  for dir in "$ROOT"/skills/*/; do
    name=$(basename "$dir")
    dest="$CODEX_SKILLS/$name"
    rm -rf "$dest"
    if $codex_link; then
      ln -s "${dir%/}" "$dest"
    else
      cp -R "${dir%/}" "$dest"
    fi
    echo "codex: $dest $($codex_link && echo '->' "${dir%/}" || echo '(copied)')"
  done
  echo "codex: done. Codex picks up skill changes automatically."
  echo "codex: for goals support, run once: codex features enable goals"
}

codex_uninstall() {
  for dir in "$ROOT"/skills/*/; do
    dest="$CODEX_SKILLS/$(basename "$dir")"
    [ -e "$dest" ] || [ -L "$dest" ] || continue
    rm -rf "$dest"
    echo "codex: removed $dest"
  done
}

status=0
if $do_claude; then
  if [ "$mode" = install ]; then claude_install || status=1; else claude_uninstall || status=1; fi
fi
if $do_codex; then
  if [ "$mode" = install ]; then codex_install; else codex_uninstall; fi
fi
exit $status
