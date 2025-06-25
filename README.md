# Dotfiles

This repository contains my personal dotfiles managed with [yadm](https://yadm.io/) (Yet Another Dotfiles Manager).

## What is yadm?

yadm is a tool for managing a collection of files across multiple diverse machines, using a shared Git repository. It's particularly useful for maintaining dotfiles across different systems.

## Setup

### Install yadm

```bash
# macOS
brew install yadm

# Ubuntu/Debian
sudo apt install yadm

# Arch Linux
sudo pacman -S yadm
```

### Clone this repository

```bash
yadm clone https://github.com/hect1c/dotfiles.git
```

### Alternative setup (if you want to start fresh)

```bash
yadm init
yadm remote add origin https://github.com/hect1c/dotfiles.git
yadm pull origin main
```

## Usage

### Adding files
```bash
yadm add <file>
yadm commit -m "Add new configuration"
yadm push
```

### Checking status
```bash
yadm status
yadm diff
```

### Updating dotfiles
```bash
yadm pull
```

## What's included

- **Neovim configuration** (`.config/nvim/`) - Complete Lua-based configuration with plugins
- **Zsh configuration** (`.zshrc`) - Shell configuration with Oh My Zsh
- Various other configuration files for development tools

## Neovim Setup

The Neovim configuration includes:
- Plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP configuration for multiple languages
- Tree-sitter for syntax highlighting
- File explorer with nvim-tree
- Fuzzy finder with telescope
- Git integration with lazygit
- Claude Code integration with [claude-code.nvim](https://github.com/greggh/claude-code.nvim)
- And many more plugins for enhanced development experience

## Notes

- This configuration is tailored for macOS but should work on Linux with minimal adjustments
- Some plugins may require additional dependencies (check individual plugin documentation)
- The configuration is constantly evolving based on my workflow needs

## License

Feel free to use any part of this configuration for your own dotfiles!