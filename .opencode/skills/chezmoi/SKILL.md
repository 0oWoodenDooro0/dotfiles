---
name: chezmoi
description: "Manage dotfiles across multiple machines using chezmoi. Use this skill when the user wants to: (1) Add files to chezmoi management, (2) Create or edit templates, (3) Manage ignore lists with .chezmoiignore, (4) Apply changes to the home directory, or (5) Understand source state attributes (prefixes/suffixes)."
---

# chezmoi

## Overview
chezmoi is a powerful dotfile manager that uses a source directory (usually a git repo) to manage files in your home directory. It supports templating, encryption, and scripts.

## Core Workflows

### 1. Adding Files
To start managing a file, use `chezmoi add`.
- For plain files: `chezmoi add ~/.bashrc`
- For templates: `chezmoi add --template ~/.gitconfig`
- For encrypted files: `chezmoi add --encrypt ~/.ssh/id_rsa`

### 2. Applying Changes
After modifying files in the source directory (via `chezmoi edit` or direct modification), apply them to your home directory:
- `chezmoi apply`
- Use `chezmoi apply -n -v` to preview changes safely.

### 3. Using Templates
Templates allow you to use different configurations on different machines.
- Syntax: `{{ .chezmoi.os }}`, `{{ if ... }}`, etc.
- See [templating.md](references/templating.md) for details.

### 4. Ignoring Files
Use `.chezmoiignore` to prevent files from being applied to specific machines.
- See [ignore.md](references/ignore.md) for details.

## Reference Material

- **Commands**: See [commands.md](references/commands.md) for a full list of commands and flags.
- **Templating**: See [templating.md](references/templating.md) for syntax, variables, and functions.
- **Ignore List**: See [ignore.md](references/ignore.md) for `.chezmoiignore` usage.
- **Attributes**: See [attributes.md](references/attributes.md) for source state prefixes (e.g., `dot_`, `executable_`) and suffixes.

## Quick Tips
- Use `chezmoi cd` to quickly jump to the source directory.
- Use `chezmoi doctor` if something isn't working as expected.
- Use `chezmoi managed` to see what's currently under control.
