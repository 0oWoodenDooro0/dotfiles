# chezmoi Templating

## Introduction
chezmoi uses Go `text/template` syntax. Templates are identified by a `.tmpl` suffix or by being in the `.chezmoitemplates/` directory.

## Syntax
- **Variables**: `{{ .variable }}`
- **Conditionals**:
  ```template
  {{ if .chezmoi.os | eq "linux" }}
    # Linux specific config
  {{ else if .chezmoi.os | eq "darwin" }}
    # macOS specific config
  {{ end }}
  ```
- **Whitespace Control**: `{{-` and `-}}` remove surrounding whitespace.

## Template Data
- **Built-in**: `.chezmoi.os`, `.chezmoi.arch`, `.chezmoi.hostname`, `.chezmoi.username`, `.chezmoi.homeDir`, `.chezmoi.sourceDir`.
- **Custom**: Defined in `chezmoi.toml` under the `[data]` section or in `.chezmoidata.$FORMAT` files.

## Functions
- **Logic**: `eq`, `ne`, `lt`, `le`, `gt`, `ge`, `not`, `and`, `or`.
- **Sprig**: Includes many utility functions like `upper`, `lower`, `replace`, `join`, etc.
- **chezmoi-specific**:
  - `include "filename"`: Include the contents of another file.
  - `template "part.tmpl" .`: Include a template fragment from `.chezmoitemplates/`.

## Testing
Use `chezmoi execute-template` to test snippets:
```bash
chezmoi execute-template '{{ .chezmoi.os }}'
```
