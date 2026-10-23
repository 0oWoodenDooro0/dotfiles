#!/usr/bin/env bash

FIFO="/tmp/ironbar_portfolio.fifo"
TOOLTIP_FILE="/tmp/portfolio_tooltip"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$1" in
  "watch")
    rm -f "$FIFO"
    mkfifo "$FIFO"
    exec 3<>"$FIFO"
    trap 'rm -f "$FIFO"; exit 0' EXIT INT TERM

    # 啟動時立即輸出一次（優先讀取快取，快取過期則抓取）
    python3 "$SCRIPT_DIR/portfolio.py" --render

    while true; do
      # 監聽事件（由點擊或快捷觸發），若 1200 秒（20 分鐘）無事件則自動喚醒重新抓取
      if read -t 1200 -u 3 event; then
        case "$event" in
          "toggle")
            python3 "$SCRIPT_DIR/portfolio.py" --toggle
            ;;
          "refresh")
            python3 "$SCRIPT_DIR/portfolio.py" --fetch
            ;;
          "click")
            # 點擊時：立馬切換顯示（瞬發 <5ms）
            python3 "$SCRIPT_DIR/portfolio.py" --toggle
            # 接著在背景連線更新最新報價，完成後通知 FIFO 重新顯示
            (python3 "$SCRIPT_DIR/portfolio.py" --fetch-quiet && echo "update" > "$FIFO") &
            ;;
          "update")
            # 最新報價抓取完畢，重新輸出畫面
            python3 "$SCRIPT_DIR/portfolio.py" --render-cache
            ;;
          *)
            python3 "$SCRIPT_DIR/portfolio.py" --render
            ;;
        esac
      else
        # 逾時 20 分鐘，自動重新抓取行情
        python3 "$SCRIPT_DIR/portfolio.py" --fetch
      fi
    done
    ;;

  "toggle")
    if [[ -p "$FIFO" ]]; then
      echo "toggle" > "$FIFO"
    else
      python3 "$SCRIPT_DIR/portfolio.py" --toggle
    fi
    ;;

  "click")
    if [[ -p "$FIFO" ]]; then
      echo "click" > "$FIFO"
    else
      python3 "$SCRIPT_DIR/portfolio.py" --toggle
    fi
    ;;

  "refresh")
    if [[ -p "$FIFO" ]]; then
      echo "refresh" > "$FIFO"
    else
      python3 "$SCRIPT_DIR/portfolio.py" --fetch
    fi
    ;;

  "tooltip")
    if [[ -f "$TOOLTIP_FILE" ]]; then
      cat "$TOOLTIP_FILE"
    else
      python3 "$SCRIPT_DIR/portfolio.py" --tooltip 2>/dev/null || echo "載入中..."
    fi
    ;;

  *)
    # 預設單次輸出
    python3 "$SCRIPT_DIR/portfolio.py" --render
    ;;
esac
