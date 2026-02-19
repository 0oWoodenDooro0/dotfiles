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
*   **[Starship](https://starship.rs/):** Cross-shell prompt (Configured for **Windows**).
*   **[Tmux](https://github.com/tmux/tmux):** Terminal multiplexer.

### Editors & Tools
*   **[Neovim](https://neovim.io/):** Powered by [LazyVim](https://www.lazyvim.org/) for a full IDE experience, including advanced Markdown rendering and preview.
*   **[Zed](https://zed.dev/):** High-performance, multiplayer code editor (Configured for both **Linux** and **Windows**).
*   **[Yazi](https://github.com/sxyazi/yazi):** Blazing fast terminal file manager (Configured for both **Linux** and **Windows**).
*   **[Lazygit](https://github.com/jesseduffield/lazygit):** Simple terminal UI for git commands.
*   **Sidecar:** A custom monitoring and workspace management tool for development.
*   **AI Assistants (OpenCode):** A modular, context-aware agent system for advanced development workflows:
    *   **Core Agents:** `OpenAgent` (universal), `OpenCoder` (coding specialist).
    *   **Specialists:** `ContextScout` (context discovery), `ExternalScout` (live documentation), `TaskManager` (complex feature breakdown).
    *   **Development:** `CoderAgent`, `TestEngineer`, `CodeReviewer`, `BuildAgent`.
    *   **System Builders:** `AgentGenerator`, `WorkflowDesigner`, `ContextOrganizer`.
*   **Custom Skills:** Specialized skills and shared logic for AI agents (e.g., `context7`, `task-management`).
*   **Context System:** A comprehensive project intelligence system with standards, workflows, and automated discovery.
*   **Sidecar:** Workspace and task monitoring configuration.

## 🛡️ AI Security & Permissions

This configuration implements a **Layered Security Model** for all AI agents:
*   **Deny-by-Default:** All unknown tools and commands require explicit user approval (`ask`).
*   **Secret Protection:** Agents are strictly forbidden from reading `*.env` files to prevent credential leakage.
*   **Safe Cleanup:** Automated `rm -rf` is strictly restricted to OS-specific temporary directories.
*   **Transparent Permissions:** Each agent includes a `## PERMISSIONS & TOOLS` manifest for better auditability.

## 🚀 Installation

### 1. Prerequisites
Ensure you have `git` and `chezmoi` installed on your system.
- **Linux:** Install via your package manager.
- **macOS:** Install via [Homebrew](https://brew.sh/) (`brew install chezmoi`).
- **Windows:** Install via [Winget](https://github.com/microsoft/winget-cli) (`winget install chezmoi`) or [Scoop](https://scoop.sh/).

### 2. Initialize & Apply
Use `chezmoi` to clone and apply the configurations in one go:

```bash
# On Linux, macOS, or Windows (PowerShell/CMD)
chezmoi init --apply https://github.com/0oWoodenDooro0/dotfiles.git
```

> **Note for macOS & Arch Linux:** The installation process will automatically install required packages (Neovim, Tmux, Yazi, etc.) via Homebrew (macOS) or Pacman/Yay (Arch Linux) using a `run_onchange_` script.

### 3. Post-Installation
*   **Zsh (Linux/macOS):** Make sure to switch your default shell to zsh: `chsh -s $(which zsh)`.
*   **Fonts:** Install a Nerd Font to ensure icons render correctly in Waybar, Starship (Windows), and Yazi.

## 📂 Structure

Here is a brief overview of the configuration mapping. The project uses `chezmoi` templates and OS-specific logic to handle cross-platform configurations.

```text
~/.local/share/chezmoi/
├── .chezmoiignore          # OS-specific ignore rules (handles Linux, Windows, and macOS)
├── .chezmoitemplates/      # Reusable configuration templates
├── run_onchange_install-packages.sh.tmpl # Automatic package installation script (macOS & Arch Linux)
│   ├── ai/                 # Shared AI templates
│   │   ├── agents/         # Agent definitions (General, Explorer, etc.)
│   │   └── skills/         # Shared logic and specialized skills
│   ├── sidecar/            # Sidecar configuration templates
│   ├── gemini/             # Gemini-specific templates (settings, themes)
│   ├── opencode/           # OpenCode-specific templates (config)
│   ├── ghostty/            # Ghostty templates
│   ├── hypr/               # Hyprland ecosystem templates
│   ├── nvim/               # Neovim templates
│   ├── starship/           # Starship prompt templates
│   ├── yazi/               # Yazi file manager templates
│   ├── zen/                # Zen Browser CSS templates
│   ├── zed/                # Zed editor templates
│   └── zsh/                # Zsh templates
├── dot_zshrc.tmpl          # Zsh configuration template (Linux and macOS)
├── dot_config/             # Linux configuration templates
│   ├── ghostty/            # Terminal config & themes
│   ├── hypr/               # Hyprland, Hyprlock, Hypridle
│   ├── nvim/               # Neovim (LazyVim)
│   ├── opencode/           # OpenCode settings & agents templates
│   ├── sidecar/            # Sidecar settings
│   ├── yazi/               # Yazi theme
│   ├── zed/                # Zed settings & keymaps
│   └── ...
├── AppData/                # Windows configuration templates
│   └── Roaming/
│       ├── yazi/           # Yazi configuration for Windows (%AppData%)
│       └── Zed/            # Zed configuration for Windows (%AppData%)
└── dot_gemini/             # AI assistant settings & skills templates
```

## ⌨️ Keybindings

*   **Hyprland:** Check `~/.config/hypr/hyprland.conf` for window management keys.
    *   **App Submap:** Press `SUPER + D` to enter application mode, then:
        *   `B`: Zen Browser
        *   `T`: Terminal (Ghostty)
        *   `D`: Discord
        *   `F`: Firefox Developer Edition
        *   `O`: Obsidian
        *   `P`: Prism Launcher
        *   `H`: Htop
        *   `C`: Google Chrome
        *   `ESC` or any other key: Exit mode.
*   **Yazi:** `y` alias in zsh allows changing directory on exit.
*   **Neovim:** Follows standard LazyVim keybindings (Leader key is `<Space>`).

## 🔄 Updates

To update your dotfiles from the remote repository:

```bash
chezmoi update
```
