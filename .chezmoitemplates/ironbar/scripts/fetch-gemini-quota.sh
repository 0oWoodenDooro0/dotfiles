#!/usr/bin/env bash

SERVICE_PORT="49999"
SERVICE_TOKEN="antigravity-quota-service-token"

# 1. 優先查詢本地常駐的 antigravity-quota 服務
RESPONSE=$(curl -s -k -m 2 -X POST "https://127.0.0.1:${SERVICE_PORT}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary" \
  -H "Content-Type: application/json" \
  -H "Connect-Protocol-Version: 1" \
  -H "X-Codeium-Csrf-Token: ${SERVICE_TOKEN}" \
  -d '{}' 2>/dev/null)

# 2. 自動回退：若常駐服務未啟動，偵測本機手動執行的 Antigravity GUI
if [[ -z "$RESPONSE" || "$RESPONSE" != *"groups"* ]]; then
  PID=$(pgrep -f "resources/bin/language_server.*standalone" | head -n 1)
  [[ -z "$PID" ]] && PID=$(pgrep -f "language_server.*antigravity" | head -n 1)

  if [[ -n "$PID" ]]; then
    CMDLINE=$(tr '\0' ' ' <"/proc/$PID/cmdline" 2>/dev/null)
    GUI_TOKEN=$(echo "$CMDLINE" | grep -oP '(?<=--csrf_token\s)[^\s]+' || echo "$CMDLINE" | grep -oP '(?<=--csrf_token=)[^\s]+')
    PORTS=($(ss -tulpn 2>/dev/null | grep "pid=$PID," | grep -oP '127\.0\.0\.1:\K[0-9]+' | sort -u))
    for P in "${PORTS[@]}"; do
      RESP=$(curl -s -k -m 2 -X POST "https://127.0.0.1:${P}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary" \
        -H "Content-Type: application/json" \
        -H "Connect-Protocol-Version: 1" \
        -H "X-Codeium-Csrf-Token: $GUI_TOKEN" \
        -d '{}' 2>/dev/null)
      if [[ "$RESP" == *"groups"* ]]; then
        RESPONSE="$RESP"
        break
      fi
    done
  fi
fi

if [[ -z "$RESPONSE" || "$RESPONSE" != *"groups"* ]]; then
  echo '{"text":"󰚩 Idle","tooltip":"Antigravity 服務未執行","class":"idle"}'
  exit 0
fi

# 3. 格式化為 Ironbar JSON
echo "$RESPONSE" | jq -c '
  def to_pct(f): if f != null then (f * 100 | round) else null end;
  def to_str(v): if v != null then "\(v)%" else "--" end;

  # Gemini Models (Flash / Pro)
  ([(.groups // .response.groups // [])[]? | select(.displayName == "Gemini Models").buckets[]?]) as $f_buckets |
  ([$f_buckets[]? | select(.bucketId == "gemini-5h")][0]) as $f_5h |
  ([$f_buckets[]? | select(.bucketId == "gemini-weekly")][0]) as $f_wk |

  to_pct($f_5h.remainingFraction) as $f_5h_val |
  to_pct($f_wk.remainingFraction) as $f_wk_val |
  to_str($f_5h_val) as $f_5h_str |
  to_str($f_wk_val) as $f_wk_str |

  # Gemini 4 Argon
  ([(.groups // .response.groups // [])[]? | select(.displayName | test("Argon"; "i")).buckets[]?]) as $ar_buckets |
  ([$ar_buckets[]? | select(.bucketId | test("5h"))][0]) as $ar_5h |
  ([$ar_buckets[]? | select(.bucketId | test("weekly"))][0] // $ar_buckets[0]) as $ar_wk |

  to_pct($ar_5h.remainingFraction) as $ar_5h_val |
  to_pct($ar_wk.remainingFraction) as $ar_wk_val |
  to_str($ar_5h_val) as $ar_5h_str |
  to_str($ar_wk_val) as $ar_wk_str |

  # Claude / GPT (3p)
  ([(.groups // .response.groups // [])[]? | select(.displayName | test("Claude|GPT|3p"; "i")).buckets[]?]) as $tp_buckets |
  ([$tp_buckets[]? | select(.bucketId == "3p-5h")][0]) as $tp_5h |
  ([$tp_buckets[]? | select(.bucketId == "3p-weekly")][0]) as $tp_wk |

  to_pct($tp_5h.remainingFraction) as $tp_5h_val |
  to_pct($tp_wk.remainingFraction) as $tp_wk_val |
  to_str($tp_5h_val) as $tp_5h_str |
  to_str($tp_wk_val) as $tp_wk_str |

  # Bar 文字組合
  (
    if $f_5h_val != null and $f_wk_val != null then
      "Flash: \($f_5h_str) (Wk: \($f_wk_str))"
    elif $f_5h_val != null then
      "Flash: \($f_5h_str)"
    elif $f_wk_val != null then
      "Flash: \($f_wk_str)"
    else
      null
    end
  ) as $flash_part |

  (
    if $ar_5h_val != null and $ar_wk_val != null then
      "Argon: \($ar_5h_str) (Wk: \($ar_wk_str))"
    elif $ar_wk_val != null then
      "Argon: \($ar_wk_str)"
    elif $ar_5h_val != null then
      "Argon: \($ar_5h_str)"
    else
      null
    end
  ) as $argon_part |

  (
    [$flash_part, $argon_part] | map(select(. != null)) | join(" | ")
  ) as $parts |

  (if ($parts | length) > 0 then "󰚩 " + $parts else "󰚩 No Data" end) as $bar_text |

  # 樣式計算 (<=15% 為 critical，<=35% 為 warning)
  ([$f_5h_val, $f_wk_val, $ar_5h_val, $ar_wk_val] | map(select(. != null)) | min // 100) as $min_val |
  (if $min_val <= 15 then "critical" elif $min_val <= 35 then "warning" else "normal" end) as $cls |

  # Tooltip 區塊
  (
    if ($f_buckets | length) > 0 then
      "【Gemini (Flash / Pro)】" +
      (if $f_5h_val != null then "\n• 5 小時額度 (5h): \($f_5h_str) (\(if $f_5h.resetTime then "重設: " + $f_5h.resetTime else "N/A" end))" else "" end) +
      (if $f_wk_val != null then "\n• 每週額度 (Wk):   \($f_wk_str) (\(if $f_wk.resetTime then "重設: " + $f_wk.resetTime else "N/A" end))" else "" end)
    else
      ""
    end
  ) as $tt_flash |

  (
    if ($ar_buckets | length) > 0 then
      "\n\n【Gemini 4 Argon】" +
      (if $ar_5h_val != null then "\n• 5 小時額度 (5h): \($ar_5h_str) (\(if $ar_5h.resetTime then "重設: " + $ar_5h.resetTime else "N/A" end))" else "" end) +
      (if $ar_wk_val != null then "\n• 每週額度 (Wk):   \($ar_wk_str) (\(if $ar_wk.resetTime then "重設: " + $ar_wk.resetTime else "N/A" end))" else "" end)
    else
      ""
    end
  ) as $tt_argon |

  (
    if ($tp_buckets | length) > 0 then
      "\n\n【Claude / GPT】" +
      (if $tp_5h_val != null then "\n• 5 小時額度 (5h): \($tp_5h_str) (\(if $tp_5h.resetTime then "重設: " + $tp_5h.resetTime else "N/A" end))" else "" end) +
      (if $tp_wk_val != null then "\n• 每週額度 (Wk):   \($tp_wk_str) (\(if $tp_wk.resetTime then "重設: " + $tp_wk.resetTime else "N/A" end))" else "" end)
    else
      ""
    end
  ) as $tt_tp |

  {
    "text": $bar_text,
    "tooltip": ("Antigravity 剩餘配額\n────────────────\n" + $tt_flash + $tt_argon + $tt_tp),
    "class": $cls
  }
' 2>/dev/null || echo '{"text":"󰚩 Parse Err","tooltip":"JSON 解析失敗","class":"error"}'
