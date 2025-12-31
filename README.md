# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start (New Machine)

### 1. Copy age key (for encrypted fonts)

```bash
mkdir -p ~/.config/chezmoi
# Paste your age key from 1Password/backup into:
# ~/.config/chezmoi/key.txt
```

### 2. Bootstrap

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply hect1c
```

### 3. Install tmux plugins

Open tmux and press `prefix + I` (Ctrl+Space, then I)

## What's Included

| Tool | Config Location | Theme |
|------|-----------------|-------|
| Neovim | ~/.config/nvim/ | Catppuccin Frappé |
| WezTerm | ~/.config/wezterm/ | Catppuccin Mocha |
| tmux | ~/.config/tmux/ | Catppuccin Mocha |
| Starship | ~/.config/starship.toml | Catppuccin Mocha |
| Zsh | ~/.zshrc | - |

## Supported Platforms

- macOS (Apple Silicon)
- Ubuntu Linux

## Updating

```bash
chezmoi update
```

## Editing

```bash
chezmoi edit ~/.zshrc    # Edit a file
chezmoi diff             # See pending changes
chezmoi apply            # Apply changes
```

## License

MIT
