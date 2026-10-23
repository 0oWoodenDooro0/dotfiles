#!/usr/bin/env bash

# 音量與靜音狀態提取 (使用 Waybar 原版 Material Design / Nerd Font v3 圖示)
VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
if [ -z "$VOL_INFO" ] || [[ "$VOL_INFO" == *"[MUTED]"* ]]; then
  echo "󰝟"
  exit 0
fi

# 轉為百分比 (例如 0.41 -> 41)
VOL=$(echo "$VOL_INFO" | awk '{print int($2 * 100)}')

if [ "$VOL" -le 33 ]; then
  echo "󰕿"
elif [ "$VOL" -le 66 ]; then
  echo "󰖀"
else
  echo "󰕾"
fi
