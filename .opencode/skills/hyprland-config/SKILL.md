---
name: hyprland-config
description: "Expert guidance for configuring Hyprland, a dynamic tiling Wayland compositor. Use this skill when the user wants to: (1) Create or modify hyprland.conf, (2) Set up keybinds, window rules, or animations, (3) Troubleshoot configuration issues, (4) Use hyprctl for dynamic changes, or (5) Understand Hyprland's configuration syntax and variables."
---

# Hyprland Config

This skill provides specialized knowledge and workflows for configuring Hyprland. It covers syntax, variables, keybinds, dispatchers, window/layer rules, and animations.

## Core Workflows

### 1. Modifying Configuration
When asked to change a setting:
1. Identify the relevant section (e.g., `general`, `decoration`, `input`).
2. Refer to [variables.md](references/variables.md) for correct names and types.
3. Provide the exact snippet for `hyprland.conf`.

### 2. Adding Keybinds
1. Determine the desired modifier and key.
2. Select the appropriate dispatcher from [binds-dispatchers.md](references/binds-dispatchers.md).
3. Check if any flags (like `e` for repeat or `l` for locked) are needed.
4. Format: `bind = MODS, key, dispatcher, params`.

### 3. Creating Window Rules
1. Use `windowrulev2` for better precision.
2. Identify the window's class or title (suggest `hyprctl clients` if unknown).
3. Select the effect from [rules.md](references/rules.md).
4. Format: `windowrulev2 = effect, match:class:^(regex)$`.

### 4. Dynamic Changes with hyprctl
For temporary changes or scripts:
- Use `hyprctl keyword <keyword> <value>` (e.g., `hyprctl keyword general:border_size 2`).
- Use `hyprctl dispatch <dispatcher> <params>` (e.g., `hyprctl dispatch workspace 1`).

## Reference Material

Load these resources as needed for detailed specifications:

- **[syntax-keywords.md](references/syntax-keywords.md)**: Basic syntax, `exec`, `source`, `env`, and per-device configs.
- **[variables.md](references/variables.md)**: Comprehensive list of configuration variables and types.
- **[binds-dispatchers.md](references/binds-dispatchers.md)**: Keybind syntax, flags, and all available dispatchers.
- **[rules.md](references/rules.md)**: Window and layer rule syntax, props, and effects.
- **[animations.md](references/animations.md)**: Animation tree, bezier curves, and styles.

## Best Practices
- **Use `windowrulev2`**: It is more modern and flexible than the old `windowrule`.
- **Regex Safety**: Always wrap regex in `^` and `$` to avoid partial matches unless intended.
- **VFR**: Keep `misc:vfr = true` for better battery life and performance.
- **Comments**: Use `#` for comments in `hyprland.conf`.
