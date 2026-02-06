#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/zserver/lib/zshort"

# Regex các file untracked cần ignore
IGNORE_REGEX='(\.factorypath|CLAUDE\.md|\.project)'

echo "🔍 Scanning git repositories under $ROOT_DIR"
echo

find "$ROOT_DIR" -type d -name ".git" | while read -r gitdir; do
  repo_dir="$(dirname "$gitdir")"
  cd "$repo_dir"

  HAS_ISSUE=false
  OUTPUT=""

  # =========
  # 1️⃣ Check uncommitted changes
  # =========
  UNCOMMITTED=$(git status --porcelain \
    | grep -vE "$IGNORE_REGEX" || true)

  if [[ -n "$UNCOMMITTED" ]]; then
    HAS_ISSUE=true
    OUTPUT+="  ⚠️  Uncommitted changes:\n"
    OUTPUT+="$(echo "$UNCOMMITTED" | sed 's/^/     /')\n"
  fi

  # =========
  # 2️⃣ Check commit chưa push
  # =========
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    read -r behind ahead < <(git rev-list --left-right --count @{u}...HEAD)
    if [[ "$ahead" -gt 0 ]]; then
      HAS_ISSUE=true
      OUTPUT+="  ⬆️  Ahead of remote by $ahead commit(s)\n"
    fi
  else
    HAS_ISSUE=true
    OUTPUT+="  ❓ No upstream branch set\n"
  fi

  # =========
  # 3️⃣ Chỉ in khi có issue
  # =========
  if [[ "$HAS_ISSUE" == true ]]; then
    echo "📁 $repo_dir"
    echo -e "$OUTPUT"
  fi
done

echo "✅ Scan completed"

