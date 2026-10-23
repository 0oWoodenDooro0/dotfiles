#!/usr/bin/env bash

CACHE_FILE="/tmp/arch-updates-cache.json"
FLAG_FILE="/tmp/arch-updates-has-updates"

# 檢查官方套件更新
OFFICIAL_UPDATES=$(checkupdates 2>/dev/null)
CHECK_STATUS=$?

if [ "$CHECK_STATUS" -eq 0 ]; then
  OFFICIAL_COUNT=$(echo "$OFFICIAL_UPDATES" | grep -c '[^[:space:]]')
elif [ "$CHECK_STATUS" -eq 2 ]; then
  # checkupdates 回傳 2 代表「目前無任何可用更新」
  OFFICIAL_COUNT=0
else
  # 發生錯誤（例如剛開機網路尚未連線、DNS 未就緒、pacman lock 等）
  # 若已有舊快取，優先輸出舊快取，不要誤判為 0 更新而導致圖示閃退或消失
  if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
  # 若無快取（例如剛開機第一次檢查），在背景排程 10 秒後重新檢查
  (sleep 10 && ~/.config/ironbar/scripts/arch-updates.sh &) &
  exit 1
fi

# 檢查 AUR 套件更新
AUR_UPDATES=$(yay -Qum 2>/dev/null)
if [ -n "$AUR_UPDATES" ]; then
  AUR_COUNT=$(echo "$AUR_UPDATES" | grep -c '[^[:space:]]')
else
  AUR_COUNT=0
fi

TOTAL_COUNT=$((OFFICIAL_COUNT + AUR_COUNT))

# 沒有更新時返回空內容並刪除標記檔
if [ "$TOTAL_COUNT" -eq 0 ]; then
  rm -f "$FLAG_FILE"
  OUTPUT='{"text": "", "tooltip": "系統已是最新狀態", "class": "updated"}'
  echo "$OUTPUT" > "$CACHE_FILE"
  echo "$OUTPUT"
  exit 0
fi

# 標記當前有更新存在（給 show_if 條件偵測）
touch "$FLAG_FILE"

# 組合 Tooltip 清單
TOOLTIP="📦 待更新總數: $TOTAL_COUNT (官方: $OFFICIAL_COUNT | AUR: $AUR_COUNT)"

# 官方套件：只取前 5 個、僅保留套件名稱
if [ "$OFFICIAL_COUNT" -gt 0 ]; then
  OFFICIAL_NAMES=$(echo "$OFFICIAL_UPDATES" | awk '{print $1}' | head -n 5)
  TOOLTIP+=$'\n\n[官方套件]\n'"$OFFICIAL_NAMES"
  if [ "$OFFICIAL_COUNT" -gt 5 ]; then
    TOOLTIP+=$'\n...等共 '"$OFFICIAL_COUNT"$'\n個套件'
  fi
fi

# AUR 套件：全部顯示、僅保留套件名稱
if [ "$AUR_COUNT" -gt 0 ]; then
  AUR_NAMES=$(echo "$AUR_UPDATES" | awk '{print $1}')
  TOOLTIP+=$'\n\n[AUR 套件]\n'"$AUR_NAMES"
fi

# 依據數量區分 class
if [ "$TOTAL_COUNT" -ge 25 ]; then
  CLASS="critical"
elif [ "$TOTAL_COUNT" -ge 10 ]; then
  CLASS="warning"
else
  CLASS="normal"
fi

# 輸出 JSON 快取
OUTPUT=$(jq -cn \
  --arg text "󰏔 $TOTAL_COUNT" \
  --arg alt "$TOTAL_COUNT" \
  --arg tooltip "$TOOLTIP" \
  --arg class "$CLASS" \
  '{"text": $text, "alt": $alt, "tooltip": $tooltip, "class": $class}')

echo "$OUTPUT" > "$CACHE_FILE"
echo "$OUTPUT"
