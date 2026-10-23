#!/usr/bin/env python3
import json
import os
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor

PRIVACY_FILE = "/tmp/waybar_portfolio_privacy"
CACHE_FILE = "/tmp/portfolio_cache.json"
TOOLTIP_FILE = "/tmp/portfolio_tooltip"
CACHE_TTL = 1200  # 20 分鐘


def get_config_path() -> str:
    env_path = os.environ.get("IRONBAR_PORTFOLIO_CONFIG") or os.environ.get(
        "IRONBAR_STOCKS_CONFIG"
    )
    if env_path:
        return env_path

    script_dir = os.path.dirname(os.path.realpath(__file__))
    candidates = [
        os.path.join(script_dir, "portfolio.json"),
        os.path.expanduser("~/.config/ironbar/scripts/portfolio.json"),
        os.path.expanduser("~/.config/ironbar/portfolio.json"),
        os.path.join(script_dir, "stocks.json"),
        os.path.expanduser("~/.config/ironbar/scripts/stocks.json"),
        os.path.expanduser("~/.config/ironbar/stocks.json"),
    ]
    for path in candidates:
        if os.path.exists(path):
            return path

    return os.path.join(script_dir, "portfolio.json")


def load_holdings() -> list:
    config_path = get_config_path()
    if not os.path.exists(config_path):
        return []
    try:
        with open(config_path, "r", encoding="utf-8") as f:
            data = json.load(f)
            if isinstance(data, list):
                return data
            elif isinstance(data, dict):
                if "holdings" in data and isinstance(data["holdings"], list):
                    return data["holdings"]
                if "stocks" in data and isinstance(data["stocks"], list):
                    return data["stocks"]
            return []
    except Exception as e:
        print(f"Error loading {config_path}: {e}", file=sys.stderr)
        return []


def is_cache_valid(cached: dict) -> bool:
    if not cached:
        return False
    ts = cached.get("timestamp", 0)
    if time.time() - ts > CACHE_TTL:
        return False
    config_path = get_config_path()
    if os.path.exists(config_path):
        try:
            if os.path.getmtime(config_path) > ts:
                return False
        except Exception:
            pass
    return True


def fetch_price(symbol: str) -> float:
    url = f"https://query1.finance.yahoo.com/v8/finance/chart/{symbol}?interval=1d"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req, timeout=5) as resp:
            data = json.loads(resp.read().decode())
            return float(data["chart"]["result"][0]["meta"]["regularMarketPrice"])
    except Exception:
        return 0.0


def fetch_all() -> dict:
    holdings = load_holdings()
    if not holdings:
        data = {
            "timestamp": time.time(),
            "total_cost_twd": 0.0,
            "total_val_twd": 0.0,
            "total_pnl_twd": 0.0,
            "total_pct": 0.0,
            "pnl_sign": "+",
            "css_class": "flat",
            "has_holdings": False,
            "tooltip": "【資產總覽】\n尚未設定持股資料，請於 portfolio.json 設定",
        }
        save_cache(data)
        return data

    symbols_to_fetch = [h["symbol"] for h in holdings] + ["USDTWD=X"]
    with ThreadPoolExecutor(max_workers=min(len(symbols_to_fetch), 10)) as executor:
        results = list(executor.map(fetch_price, symbols_to_fetch))

    prices = dict(zip(symbols_to_fetch, results))
    fx_rate = prices.get("USDTWD=X", 0.0) or 32.0

    total_cost_twd = 0.0
    total_val_twd = 0.0
    details = []

    for h in holdings:
        price = prices.get(h["symbol"], 0.0)
        cost = float(h.get("cost", 0.0))
        shares = float(h.get("shares", 0.0))
        cur = h.get("currency", "TWD")
        name = h.get("name", h.get("symbol", ""))

        val_orig = shares * price
        pnl_orig = val_orig - cost
        pct = (pnl_orig / cost) * 100 if cost > 0 else 0.0
        sign = "+" if pnl_orig > 0 else ""

        rate = fx_rate if cur == "USD" else 1.0
        total_cost_twd += cost * rate
        total_val_twd += val_orig * rate

        details.append(
            f"{name:<6} 現價: {price:>7.2f} {cur} | 成本: {cost:>7.1f} {cur}\n"
            f"       現值: {val_orig:>7.1f} {cur} | 損益: {sign}{pnl_orig:>7.1f} {cur} ({sign}{pct:.2f}%)"
        )

    total_pnl_twd = total_val_twd - total_cost_twd
    total_pct = (total_pnl_twd / total_cost_twd) * 100 if total_cost_twd > 0 else 0.0
    pnl_sign = "+" if total_pnl_twd > 0 else ""
    css_class = "up" if total_pnl_twd > 0 else ("down" if total_pnl_twd < 0 else "flat")

    tooltip_lines = [
        f"【資產總覽 (TWD)】 (USD/TWD: {fx_rate:.2f})",
        f"總成本: NT${total_cost_twd:,.0f}",
        f"總現值: NT${total_val_twd:,.0f}",
        f"總損益: {pnl_sign}NT${total_pnl_twd:,.0f} ({pnl_sign}{total_pct:.2f}%)",
        "--------------------------------------------",
        "【持股明細 (原始幣別)】",
    ] + details

    data = {
        "timestamp": time.time(),
        "total_cost_twd": total_cost_twd,
        "total_val_twd": total_val_twd,
        "total_pnl_twd": total_pnl_twd,
        "total_pct": total_pct,
        "pnl_sign": pnl_sign,
        "css_class": css_class,
        "has_holdings": True,
        "tooltip": "\n".join(tooltip_lines),
    }

    save_cache(data)
    return data


def save_cache(data: dict):
    try:
        with open(CACHE_FILE, "w") as f:
            json.dump(data, f, ensure_ascii=False)
        with open(TOOLTIP_FILE, "w") as f:
            f.write(data["tooltip"])
    except Exception:
        pass


def load_cache() -> dict:
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                return json.load(f)
        except Exception:
            pass
    return None


def format_markup(data: dict) -> str:
    if not data.get("has_holdings", True) and data.get("total_val_twd", 0.0) == 0.0:
        return "<span foreground='#6c7086'>未設定持股</span>"

    is_masked = os.path.exists(PRIVACY_FILE)
    pnl_sign = data.get("pnl_sign", "+")
    total_pct = data.get("total_pct", 0.0)
    total_val_twd = data.get("total_val_twd", 0.0)
    total_pnl_twd = data.get("total_pnl_twd", 0.0)
    css_class = data.get("css_class", "flat")

    if is_masked:
        bar_text = f"**** ({pnl_sign}{total_pct:.2f}%)"
    else:
        bar_text = f"${total_val_twd:,.0f} ({pnl_sign}{total_pnl_twd:,.0f} | {pnl_sign}{total_pct:.2f}%)"

    if css_class == "up":
        color = "#a6e3a1"
    elif css_class == "down":
        color = "#f38ba8"
    else:
        color = "#6c7086"

    return f"<span foreground='{color}'>{bar_text}</span>"


def toggle_privacy():
    if os.path.exists(PRIVACY_FILE):
        os.remove(PRIVACY_FILE)
    else:
        with open(PRIVACY_FILE, "w") as f:
            pass


def main():
    arg = sys.argv[1] if len(sys.argv) > 1 else "--render"

    if arg in ("toggle", "--toggle"):
        toggle_privacy()
        cached = load_cache()
        if cached:
            print(format_markup(cached), flush=True)
        else:
            data = fetch_all()
            print(format_markup(data), flush=True)
        sys.exit(0)

    elif arg in ("fetch", "--fetch"):
        data = fetch_all()
        print(format_markup(data), flush=True)
        sys.exit(0)

    elif arg in ("fetch-quiet", "--fetch-quiet"):
        fetch_all()
        sys.exit(0)

    elif arg in ("render-cache", "--render-cache"):
        cached = load_cache()
        if cached:
            print(format_markup(cached), flush=True)
        else:
            data = fetch_all()
            print(format_markup(data), flush=True)
        sys.exit(0)

    elif arg in ("tooltip", "--tooltip"):
        if os.path.exists(TOOLTIP_FILE):
            with open(TOOLTIP_FILE, "r") as f:
                print(f.read())
        else:
            cached = load_cache()
            if cached and "tooltip" in cached:
                print(cached["tooltip"])
            else:
                data = fetch_all()
                print(data["tooltip"])
        sys.exit(0)

    elif arg in ("json", "--json"):
        cached = load_cache()
        if not is_cache_valid(cached):
            cached = fetch_all()
        is_masked = os.path.exists(PRIVACY_FILE)
        pnl_sign = cached.get("pnl_sign", "+")
        total_pct = cached.get("total_pct", 0.0)
        total_val_twd = cached.get("total_val_twd", 0.0)
        total_pnl_twd = cached.get("total_pnl_twd", 0.0)
        if not cached.get("has_holdings", True) and total_val_twd == 0.0:
            bar_text = "未設定持股"
        elif is_masked:
            bar_text = f"**** ({pnl_sign}{total_pct:.2f}%)"
        else:
            bar_text = f"${total_val_twd:,.0f} ({pnl_sign}{total_pnl_twd:,.0f} | {pnl_sign}{total_pct:.2f}%)"
        print(
            json.dumps(
                {
                    "text": bar_text,
                    "tooltip": cached.get("tooltip", ""),
                    "class": cached.get("css_class", "flat"),
                },
                ensure_ascii=False,
            )
        )
        sys.exit(0)

    else:
        # --render
        cached = load_cache()
        if is_cache_valid(cached):
            print(format_markup(cached), flush=True)
        else:
            try:
                data = fetch_all()
                print(format_markup(data), flush=True)
            except Exception:
                if cached:
                    print(format_markup(cached), flush=True)
                else:
                    print(
                        "<span foreground='#6c7086'>無法取得股票資訊</span>", flush=True
                    )


if __name__ == "__main__":
    main()
