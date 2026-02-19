# Hyprland Syntax & Keywords

## Basic Syntax
- Arguments are separated by commas (`,`).
- If an argument is empty, you must still include the comma (unless it's the last one and the section says otherwise).
- `keyword = arg1, arg2, arg3`

## Executing
- `exec-once = command`: Execute only on launch.
- `exec = command`: Execute on each config reload.
- `exec-shutdown = command`: Execute on shutdown.
- `execr-once` / `execr`: Raw execution (no rules support).

## Sourcing
- `source = path`: Source another config file. Globbing supported (e.g., `source = ~/.config/hypr/conf.d/*`).

## Environment Variables
- `env = NAME,VALUE`: Set environment variable. Do NOT use quotes.
- `envd = NAME,VALUE`: Export to D-Bus (systemd only).

## Per-device Config
```ini
device {
    name = device-name
    # options...
}
```
Get names via `hyprctl devices`.
Supported options: most from `input` and `input:touchpad`, except `force_no_accel`, `follow_mouse`, `float_switch_override_focus`.
Additional: `enabled` (bool), `keybinds` (bool).
