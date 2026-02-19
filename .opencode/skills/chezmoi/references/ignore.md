# .chezmoiignore

## Purpose
The `.chezmoiignore` file specifies files and directories that chezmoi should ignore when applying the source state to the destination.

## Usage
- Create a file named `.chezmoiignore` in the root of your source directory.
- It supports shell-style patterns (globs).
- It is itself a template, so you can ignore files conditionally.

## Examples
```template
# Ignore all .txt files
*.txt

# Ignore a specific directory
private/

# Conditional ignore
{{ if ne .chezmoi.os "linux" }}
.bashrc
{{ end }}
```

## Note
Files ignored by `.chezmoiignore` will not be created in the destination, even if they exist in the source state.
