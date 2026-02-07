# 🔧 My Dotfiles

Welcome to my personal configuration files (dotfiles). This repository is managed with [chezmoi](https://www.chezmoi.io/) and features a cohesive, aesthetically pleasing setup centered around the **Catppuccin Mocha** color scheme.

## 🎨 Theme & Aesthetics

*   **Color Scheme:** [Catppuccin Mocha](https://github.com/catppuccin/catppuccin)
*   **Font:** [Nerd Fonts](https://www.nerdfonts.com/) (Recommended: JetBrainsMono Nerd Font or similar)

## 📦 What's Included?

This setup configures the following tools:

### Window Management & Desktop
*   **[Hyprland](https://hyprland.org/):** Dynamic tiling window manager (Wayland).
*   **[Waybar](https://github.com/Alexays/Waybar):** Highly customizable Wayland bar.
*   **[Rofi](https://github.com/davatorium/rofi):** Application launcher and window switcher.
*   **[Wlogout](https://github.com/ArtsyMacaroni/wlogout):** Logout menu.
*   **[Hyprlock](https://wiki.hyprland.org/Hypr-Ecosystem/Hyprlock/) & [Hypridle](https://wiki.hyprland.org/Hypr-Ecosystem/Hypridle/):** Screen locking and idle management.

### Terminal & Shell
*   **[Ghostty](https://github.com/ghostty-org/ghostty):** Fast, feature-rich terminal emulator.
*   **[Zsh](https://www.zsh.org/):** Shell configuration with [Oh My Zsh](https://ohmyz.sh/).
*   **[Starship](https://starship.rs/):** Cross-shell prompt.
*   **[Tmux](https://github.com/tmux/tmux):** Terminal multiplexer.

### Editors & Tools
*   **[Neovim](https://neovim.io/):** Powered by [LazyVim](https://www.lazyvim.org/) for a full IDE experience.
*   **[Yazi](https://github.com/sxyazi/yazi):** Blazing fast terminal file manager (Configured for both **Linux** and **Windows**).
*   **[Lazygit](https://github.com/jesseduffield/lazygit):** Simple terminal UI for git commands.
*   **OpenCode & Gemini CLI:** AI assistant configuration with specialized agents (like **The Librarian** for codebase analysis) and shared custom skills for Obsidian.

## 🚀 Installation

### 1. Prerequisites
Ensure you have `git` and `chezmoi` installed on your system.
- **Linux:** Install via your package manager.
- **Windows:** Install via [Winget](https://github.com/microsoft/winget-cli) (`winget install chezmoi`) or [Scoop](https://scoop.sh/).

### 2. Initialize & Apply
Use `chezmoi` to clone and apply the configurations in one go:

```bash
# On Linux or Windows (PowerShell/CMD)
chezmoi init --apply https://github.com/0oWoodenDooro0/dotfiles.git
```

### 3. Post-Installation
*   **Zsh (Linux):** Make sure to switch your default shell to zsh: `chsh -s $(which zsh)`.
*   **Fonts:** Install a Nerd Font to ensure icons render correctly in Waybar, Starship, and Yazi.

## 📂 Structure

Here is a brief overview of the configuration mapping. The project uses `chezmoi` templates and OS-specific logic to handle cross-platform configurations.

```text
~/.local/share/chezmoi/
├── .chezmoiignore          # OS-specific ignore rules (handles Linux vs Windows)
├── .chezmoitemplates/      # Reusable configuration templates
│   ├── ai/                 # Shared AI templates (agents, skills)
│   ├── gemini/             # Gemini-specific templates (settings, themes)
│   ├── opencode/           # OpenCode-specific templates (config)
│   ├── ghostty/            # Ghostty templates
│   ├── hypr/               # Hyprland ecosystem templates
│   ├── nvim/               # Neovim templates
│   ├── starship/           # Starship prompt templates
│   ├── yazi/               # Yazi file manager templates
│   ├── zen/                # Zen Browser CSS templates
│   └── zsh/                # Zsh templates
├── dot_zshrc.tmpl          # Zsh configuration template (Linux only)
├── dot_config/             # Linux configuration templates
│   ├── ghostty/            # Terminal config & themes
│   ├── hypr/               # Hyprland, Hyprlock, Hypridle
│   ├── nvim/               # Neovim (LazyVim)
│   ├── opencode/           # OpenCode settings & agents templates
│   ├── yazi/               # Yazi theme
│   └── ...
├── AppData/                # Windows configuration templates
│   └── Roaming/yazi/       # Yazi configuration for Windows (%AppData%)
└── dot_gemini/             # AI assistant settings & skills templates
```

## ⌨️ Keybindings

*   **Hyprland:** Check `~/.config/hypr/hyprland.conf` for window management keys.
*   **Yazi:** `y` alias in zsh allows changing directory on exit.
*   **Neovim:** Follows standard LazyVim keybindings (Leader key is `<Space>`).

## 🔄 Updates

To update your dotfiles from the remote repository:

```bash
chezmoi update
```
