#!/usr/bin/env bash

# 複用現有的 gemini-quota 腳本
OUTPUT=$("$HOME/.config/ironbar/scripts/fetch-gemini-quota.sh" 2>/dev/null)
if [ -z "$OUTPUT" ]; then
  exit 0
fi

TEXT=$(echo "$OUTPUT" | jq -r '.text // empty')
CLASS=$(echo "$OUTPUT" | jq -r '.class // empty')

if [ -z "$TEXT" ]; then
  exit 0
fi

case "$CLASS" in
  "critical")
    echo "<span foreground='#f38ba8' weight='bold'>$TEXT</span>"
    ;;
  "warning")
    echo "<span foreground='#f9e2af'>$TEXT</span>"
    ;;
  "error")
    echo "<span foreground='#eba0ac'>$TEXT</span>"
    ;;
  "idle")
    echo "<span foreground='#6c7086'>$TEXT</span>"
    ;;
  *)
    echo "<span foreground='#cba6f7'>$TEXT</span>"
    ;;
esac
