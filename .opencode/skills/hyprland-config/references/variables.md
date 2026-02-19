# Hyprland Variables

## Variable Types
- `int`: Integer
- `bool`: `true`/`false`, `yes`/`no`, `on`/`off`, `0`/`1`
- `float`: Floating point
- `color`: `rgba(b3ff1aee)`, `rgb(b3ff1a)`, or `0xeeb3ff1a` (ARGB)
- `gradient`: `color color ... [angle]` (e.g., `rgba(11ee11ff) rgba(1111eeff) 45deg`)
- `vec2`: Two floats (e.g., `0 0`)
- `str`: String

## Core Sections

### General
- `border_size` (int): Border width.
- `gaps_in` (int): Gaps between windows.
- `gaps_out` (int): Gaps between windows and monitor edges.
- `col.active_border` (gradient): Active window border color.
- `col.inactive_border` (gradient): Inactive window border color.
- `layout` (str): `dwindle` or `master`.

### Decoration
- `rounding` (int): Corner radius.
- `active_opacity` (float): 0.0 - 1.0.
- `inactive_opacity` (float): 0.0 - 1.0.
- `dim_inactive` (bool): Dim inactive windows.
- `blur { enabled, size, passes }`: Background blur settings.
- `shadow { enabled, range, color }`: Drop shadow settings.

### Input
- `kb_layout` (str): Keyboard layout (e.g., `us`).
- `kb_options` (str): XKB options (e.g., `caps:escape`).
- `follow_mouse` (int): 0 (none), 1 (always), 2 (detached), 3 (separate).
- `sensitivity` (float): -1.0 to 1.0.
- `touchpad { natural_scroll, tap-to-click }`: Touchpad specific.

### Misc
- `disable_hyprland_logo` (bool): Disable startup logo.
- `vfr` (bool): Variable Frame Rate (recommended: true).
- `vrr` (int): Adaptive Sync (0: off, 1: on, 2: fullscreen).
- `mouse_move_enables_dpms` (bool): Wake monitor on mouse move.

### Binds
- `workspace_back_and_forth` (bool): Switch to previous workspace if current is focused.
- `allow_workspace_cycles` (bool): Enable workspace cycling.
