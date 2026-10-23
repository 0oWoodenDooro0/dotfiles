#!/usr/bin/env bash

# 1. 自動偵測 language_server PID 與 CSRF Token
PID=$(pgrep -f "resources/bin/language_server" | head -n 1)
if [[ -z "$PID" ]]; then
  PID=$(pgrep -f "language_server.*antigravity" | head -n 1)
fi

if [[ -z "$PID" ]]; then
  echo '{"text":"󰚩 Idle","tooltip":"Antigravity 服務未執行","class":"idle"}'
  exit 0
fi

CMDLINE=$(tr '\0' ' ' <"/proc/$PID/cmdline" 2>/dev/null)
TOKEN=$(echo "$CMDLINE" | grep -oP '(?<=--csrf_token\s)[^\s]+' || echo "$CMDLINE" | grep -oP '(?<=--csrf_token=)[^\s]+')

# 2. 獲取本地監聽埠清單
PORTS=($(ss -tulpn 2>/dev/null | grep "pid=$PID," | grep -oP '127\.0\.0\.1:\K[0-9]+' | sort -u))
if [[ ${#PORTS[@]} -eq 0 ]]; then
  echo '{"text":"󰚩 Idle","tooltip":"找不到本地監聽連接埠","class":"idle"}'
  exit 0
fi

RESPONSE=""

# 3. 探測有效的 HTTPS RPC 端點
for P in "${PORTS[@]}"; do
  RESP=$(curl -s -k -m 2 -X POST "https://127.0.0.1:${P}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary" \
    -H "Content-Type: application/json" \
    -H "Connect-Protocol-Version: 1" \
    -H "X-Codeium-Csrf-Token: $TOKEN" \
    -d '{}' 2>/dev/null)

  if [[ "$RESP" == *"gemini-weekly"* ]]; then
    RESPONSE="$RESP"
    break
  fi
done

if [[ -z "$RESPONSE" ]]; then
  echo '{"text":"󰚩 Err","tooltip":"無法連線至本地配額服務","class":"error"}'
  exit 0
fi

# 4. 精確提取 Gemini 的 Weekly 與 5h 額度
echo "$RESPONSE" | jq -c '
  # 鎖定 Gemini Models 群組下的 buckets
  (.response.groups[]? | select(.displayName == "Gemini Models").buckets) as $buckets |

  # 提取 5h 與 weekly bucket
  ($buckets[]? | select(.bucketId == "gemini-5h")) as $b_5h |
  ($buckets[]? | select(.bucketId == "gemini-weekly")) as $b_wk |

  # 百分比轉換
  (if $b_5h.remainingFraction != null then ($b_5h.remainingFraction * 100 | round) else null end) as $h5_val |
  (if $b_wk.remainingFraction != null then ($b_wk.remainingFraction * 100 | round) else null end) as $wk_val |

  (if $h5_val != null then "\($h5_val)%" else "--" end) as $h5_str |
  (if $wk_val != null then "\($wk_val)%" else "--" end) as $wk_str |

  ($b_5h.resetTime // "N/A") as $h5_reset |
  ($b_wk.resetTime // "N/A") as $wk_reset |

  # 依照最低額度設定樣式 (<=15% 為 critical，<=35% 為 warning)
  ([$h5_val, $wk_val] | map(select(. != null)) | min // 100) as $min_val |
  (if $min_val <= 15 then "critical" elif $min_val <= 35 then "warning" else "normal" end) as $cls |

  {
    "text": "󰚩 5h: \($h5_str) | Wk: \($wk_str)",
    "tooltip": "Gemini 剩餘配額\n────────────────\n• 5 小時額度 (5h): \($h5_str) (重設: \($h5_reset))\n• 每週額度 (Wk):  \($wk_str) (重設: \($wk_reset))",
    "class": $cls
  }
' 2>/dev/null || echo '{"text":"󰚩 Parse Err","tooltip":"JSON 解析失敗","class":"error"}'
