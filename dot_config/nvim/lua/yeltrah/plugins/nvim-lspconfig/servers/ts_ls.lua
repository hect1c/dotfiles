return function(on_attach)
  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    init_options = {
      hostInfo = 'neovim',
    },
    -- Use root_markers for Neovim 0.11+ (replaces root_dir function)
    root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', 'node_modules' },
    single_file_support = true,
  }
end
