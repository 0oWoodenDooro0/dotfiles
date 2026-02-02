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
*   **[Yazi](https://github.com/sxyazi/yazi):** Blazing fast terminal file manager.
*   **[Lazygit](https://github.com/jesseduffield/lazygit):** Simple terminal UI for git commands.
*   **Gemini CLI:** Configurations for Google's AI assistant CLI.

## 🚀 Installation

### 1. Prerequisites
Ensure you have `git` and `chezmoi` installed on your system. You will also need the core tools listed above (Hyprland, Neovim, etc.) installed via your distribution's package manager.

### 2. Initialize & Apply
Use `chezmoi` to clone and apply the configurations in one go:

```bash
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git
```

### 3. Post-Installation
*   **Zsh:** Make sure to switch your default shell to zsh: `chsh -s $(which zsh)`.
*   **Fonts:** Install a Nerd Font to ensure icons render correctly in Waybar and Starship.

## 📂 Structure

Here is a brief overview of the configuration mapping:

```text
~/.local/share/chezmoi/
├── dot_zshrc               # Zsh configuration
├── dot_config/
│   ├── ghostty/            # Terminal config & themes
│   ├── hypr/               # Hyprland, Hyprlock, Hypridle
│   ├── nvim/               # Neovim (LazyVim)
│   ├── tmux/               # Tmux settings
│   ├── waybar/             # Status bar config & styling
│   ├── yazi/               # File manager theme
│   └── ...                 # Other configs (rofi, wlogout, lazygit)
└── dot_gemini/             # AI assistant settings
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
