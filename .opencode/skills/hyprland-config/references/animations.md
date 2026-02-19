# Hyprland Animations

## Syntax
`animation = NAME, ONOFF, SPEED, CURVE [,STYLE]`
- `ONOFF`: `1` (on), `0` (off).
- `SPEED`: In deciseconds (1ds = 100ms).
- `CURVE`: Bezier curve name.
- `STYLE`: Optional (e.g., `slide`, `popin`, `fade`).

## Bezier Curves
`bezier = NAME, X0, Y0, X1, Y1`
Example: `bezier = myBezier, 0.05, 0.9, 0.1, 1.05`

## Animation Tree (Common Names)
- `global`
  - `windows` (styles: `slide`, `popin`)
    - `windowsIn` / `windowsOut` / `windowsMove`
  - `fade`
    - `fadeIn` / `fadeOut` / `fadeSwitch`
  - `border` / `borderangle`
  - `workspaces` (styles: `slide`, `slidevert`, `fade`, `slidefade`)
    - `specialWorkspace`

## Examples
```ini
bezier = myBezier, 0.05, 0.9, 0.1, 1.05
animation = windows, 1, 7, myBezier
animation = windowsOut, 1, 7, default, popin 80%
animation = border, 1, 10, default
animation = fade, 1, 7, default
animation = workspaces, 1, 6, default
```
