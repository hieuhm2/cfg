#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/zserver/lib"

SINCE=""
UNTIL=""
AUTHOR="$(git config user.name)"
MARKDOWN=false

usage() {
  echo "Usage:"
  echo "  $0 [--author NAME] [--since TIME] [--until TIME] [--markdown]"
  echo
  echo "Examples:"
  echo "  $0 --since '7 days ago'"
  echo "  $0 --author 'Nguyen Van A' --since '1 month ago'"
  echo "  $0 --since '2026-04-01' --until '2026-04-05'"
  echo "  $0 --since '7 days ago' --markdown"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --since)
      SINCE="$2"
      shift 2
      ;;
    --until)
      UNTIL="$2"
      shift 2
      ;;
    --author)
      AUTHOR="$2"
      shift 2
      ;;
    --markdown)
      MARKDOWN=true
      shift
      ;;
    *)
      usage
      ;;
  esac
done

echo "Author : $AUTHOR"
echo "Since  : ${SINCE:-beginning}"
echo "Until  : ${UNTIL:-now}"
echo

TOTAL_COMMITS=0

find "$ROOT_DIR" -type d -name ".git" | while read -r gitdir; do
  repo_dir="$(dirname "$gitdir")"
  repo_name="$(basename "$repo_dir")"

  pushd "$repo_dir" > /dev/null

  log_args=(
    --author="$AUTHOR"
    --pretty=format:"%h|%ad|%s"
    --date=iso
  )

  [[ -n "$SINCE" ]] && log_args+=(--since="$SINCE")
  [[ -n "$UNTIL" ]] && log_args+=(--until="$UNTIL")

  commits=$(git log "${log_args[@]}" || true)

  if [[ -n "$commits" ]]; then
    count=$(echo "$commits" | wc -l)
    TOTAL_COMMITS=$((TOTAL_COMMITS + count))

    if [[ "$MARKDOWN" = true ]]; then
      echo "## $repo_name ($count commits)"
      echo "$commits" | while IFS='|' read -r hash date msg; do
        echo "- $msg ($hash)"
      done
      echo
    else
      echo "📦 $repo_name ($count commits)"
      echo "$commits" | while IFS='|' read -r hash date msg; do
        printf "  %s  %s  %s\n" "$hash" "$date" "$msg"
      done
      echo
    fi
  fi

  popd > /dev/null

done

echo "============================="
echo "Total commits: $TOTAL_COMMITS"
