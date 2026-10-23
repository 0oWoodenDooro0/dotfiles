#!/usr/bin/env bash

CACHE_FILE="/tmp/arch-updates-cache.json"

if [ -f "$CACHE_FILE" ]; then
  TOOLTIP=$(jq -r '.tooltip // empty' "$CACHE_FILE" 2>/dev/null)
  if [ -n "$TOOLTIP" ]; then
    echo "$TOOLTIP"
    exit 0
  fi
fi

echo "檢查更新中..."
