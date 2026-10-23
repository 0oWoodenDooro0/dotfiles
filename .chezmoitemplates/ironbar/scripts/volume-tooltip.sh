#!/usr/bin/env bash

# 顯示百分比 Tooltip (例如 41%)
VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
if [ -z "$VOL_INFO" ]; then
  echo "0%"
  exit 0
fi

if [[ "$VOL_INFO" == *"[MUTED]"* ]]; then
  echo "$VOL_INFO" | awk '{print int($2 * 100)"% [靜音]"}'
  exit 0
fi

echo "$VOL_INFO" | awk '{print int($2 * 100)"%"}'
