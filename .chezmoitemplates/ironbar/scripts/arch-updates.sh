#!/usr/bin/env bash

CACHE_FILE="/tmp/arch-updates-cache.json"
FLAG_FILE="/tmp/arch-updates-has-updates"

# 執行檢查更新腳本
OUTPUT=$(~/.config/ironbar/scripts/fetch-arch-updates.sh 2>/dev/null)
if [ -z "$OUTPUT" ]; then
  exit 0
fi

TEXT=$(echo "$OUTPUT" | jq -r '.text // empty')
CLASS=$(echo "$OUTPUT" | jq -r '.class // empty')

# 如果更新數量為 0 或狀態為已更新，移除標記並退出
if [ -z "$TEXT" ] || [ "$CLASS" = "updated" ]; then
  rm -f "$FLAG_FILE"
  exit 0
fi

# 標記當前有更新存在
touch "$FLAG_FILE"

# 使用 Pango Markup 配合 Catppuccin Mocha 顏色
case "$CLASS" in
  "critical")
    echo "<span foreground='#f38ba8' weight='bold'>$TEXT</span>"
    ;;
  "warning")
    echo "<span foreground='#f9e2af'>$TEXT</span>"
    ;;
  *)
    echo "<span foreground='#89b4fa'>$TEXT</span>"
    ;;
esac

exit 0
