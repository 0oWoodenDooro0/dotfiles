#!/usr/bin/env bash

nmcli -t -f IN-USE,SSID,SIGNAL dev wifi 2>/dev/null | grep '^\*' | awk -F: '{print $2 " (" $3 "%)"}'
