# Hyprland Window & Layer Rules

## Window Rules
`windowrule = EFFECT, PROPS`
`windowrulev2 = EFFECT, PROPS` (Recommended for better matching)

### Props (Matching)
- `class`: Window class (regex).
- `title`: Window title (regex).
- `initialClass` / `initialTitle`: Match on creation.
- `floating`: `0` or `1`.
- `fullscreen`: `0` or `1`.
- `workspace`: Workspace ID or name.

### Effects
- `float`: Float the window.
- `tile`: Tile the window.
- `fullscreen`: Fullscreen the window.
- `move x y`: Move floating window.
- `size w h`: Resize floating window.
- `workspace w`: Open on specific workspace.
- `opacity a`: Set opacity (e.g., `0.8 override`).
- `bordercolor c`: Set border color.
- `idleinhibit [none|always|focus|fullscreen]`: Prevent sleep.

### Example
```ini
windowrulev2 = float, class:^(kitty)$, title:^(top)$
windowrulev2 = opacity 0.8 0.8, class:^(firefox)$
windowrulev2 = workspace 2, class:^(discord)$
```

## Layer Rules
Used for bars, launchers, etc.
`layerrule = EFFECT, NAMESPACE`

### Effects
- `blur`: Enable blur.
- `ignorealpha [a]`: Ignore transparency in blur.
- `noanim`: Disable animations.

### Example
```ini
layerrule = blur, waybar
layerrule = ignorealpha 0.5, waybar
```
