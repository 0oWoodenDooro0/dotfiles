# chezmoi Commands

## Core Commands

- **`add [target...]`**: Add files or directories to the source state.
  - `-T, --template`: Add as a template.
  - `-a, --autotemplate`: Auto-generate template by replacing data values.
  - `--encrypt`: Encrypt file in source state.
  - `--create`: Set `create_` attribute.
- **`apply [target...]`**: Update the destination (home directory) to match the source state.
  - `-n, --dry-run`: Show changes without applying.
  - `-v, --verbose`: Print changes.
- **`init [repo]`**: Initialize the source directory. If a repo is provided, it clones it.
- **`update`**: Pull changes from the remote repository and apply them.
- **`diff [target...]`**: Show differences between the destination and the source state.
- **`status [target...]`**: Show a summary of changes.
- **`edit [target...]`**: Edit the source file for a target.
- **`forget [target...]`**: Stop managing a target (removes it from source state but keeps it in destination).
- **`managed`**: List all managed files.
- **`unmanaged`**: List all unmanaged files in the destination.

## Utility Commands

- **`cd`**: Open a subshell in the source directory.
- **`doctor`**: Check for common problems.
- **`execute-template [template]`**: Execute a template string or file and print the result.
