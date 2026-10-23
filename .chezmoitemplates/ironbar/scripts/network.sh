#!/usr/bin/env bash

ACTIVE_CONN=$(nmcli -t -f TYPE,STATE dev 2>/dev/null | grep -E '^(wifi|ethernet):connected' | head -n 1)
TYPE=$(echo "$ACTIVE_CONN" | cut -d: -f1)

if [[ "$TYPE" == "ethernet" ]]; then
  echo "󰈀"
elif [[ "$TYPE" == "wifi" ]]; then
  SIGNAL=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | grep '^\*' | cut -d: -f2 | head -n 1)
  SIGNAL=${SIGNAL:-0}
  if [ "$SIGNAL" -ge 80 ]; then
    echo "󰤨"
  elif [ "$SIGNAL" -ge 60 ]; then
    echo "󰤥"
  elif [ "$SIGNAL" -ge 40 ]; then
    echo "󰤢"
  elif [ "$SIGNAL" -ge 20 ]; then
    echo "󰤟"
  else
    echo "󰤯"
  fi
else
  echo "󰤭"
fi
