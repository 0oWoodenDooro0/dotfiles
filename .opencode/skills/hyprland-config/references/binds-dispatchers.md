# Hyprland Binds & Dispatchers

## Binds Syntax
`bind[flags] = MODS, key, dispatcher, params`

### Common Flags
- `l`: Locked (works on lockscreen)
- `r`: Release (triggers on key release)
- `e`: Repeat (repeats when held)
- `m`: Mouse (for `movewindow` and `resizewindow`)
- `n`: Non-consuming (passes event to app too)
- `i`: Ignore mods
- `d`: Has description (`bindd = MODS, key, description, dispatcher, params`)

### Modifiers
`SHIFT`, `CAPS`, `CTRL`, `ALT`, `SUPER` (or `WIN`, `LOGO`, `MOD4`)

## Common Dispatchers
- `exec, command`: Run a shell command.
- `killactive`: Close active window.
- `workspace, workspace`: Change workspace.
- `movetoworkspace, workspace`: Move window to workspace.
- `togglefloating`: Toggle floating state.
- `fullscreen, [0/1]`: 0 = full, 1 = maximize.
- `movefocus, [l/r/u/d]`: Move focus.
- `movewindow, [l/r/u/d]`: Move window.
- `resizeactive, x y`: Resize active window.
- `togglespecialworkspace, [name]`: Toggle scratchpad.
- `submap, name`: Switch to a submap (use `reset` to exit).

## Mouse Binds
`bindm = MODS, mouse:272, movewindow` (LMB)
`bindm = MODS, mouse:273, resizewindow` (RMB)

## Workspaces
- ID: `1`, `2`...
- Relative: `+1`, `-1`
- Monitor relative: `m+1`, `m-1`
- Open relative: `e+1`, `e-1`
- Name: `name:Web`
- Special: `special` or `special:name`
