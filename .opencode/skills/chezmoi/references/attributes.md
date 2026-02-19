# Source State Attributes

chezmoi uses prefixes and suffixes in the source directory to encode the state of files.

## Common Prefixes
- **`dot_`**: Target will have a leading dot (e.g., `dot_bashrc` -> `.bashrc`).
- **`executable_`**: Target will have executable permissions.
- **`private_`**: Target will have restricted permissions (0600 or 0700).
- **`readonly_`**: Target will be read-only.
- **`empty_`**: Target will be created even if empty.
- **`create_`**: Target will only be created if it doesn't exist.
- **`encrypted_`**: File is encrypted in the source state.
- **`run_`**: File is a script to be executed.
  - `run_once_`: Run only if content changes or hasn't run before.
  - `run_onchange_`: Run whenever the content changes.
  - `run_before_`: Run before applying other changes.
  - `run_after_`: Run after applying other changes.

## Common Suffixes
- **`.tmpl`**: File is a template and will be processed before being applied.
- **`.literal`**: Stop parsing attributes.
