return function(on_attach)
  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
    -- Use root_markers for Neovim 0.11+ (replaces root_dir function)
    root_markers = { 'composer.json', '.git' },
    single_file_support = true,
  }
end
