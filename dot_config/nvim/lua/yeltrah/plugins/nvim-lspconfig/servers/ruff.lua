return function(on_attach)
  return {
    on_attach = on_attach,
    -- Specify filetypes explicitly to ensure proper detection
    filetypes = { 'python' },
    -- Use root_markers for Neovim 0.11+ (replaces root_dir function)
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  }
end