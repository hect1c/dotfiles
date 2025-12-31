return function(on_attach)
  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end,
    settings = {
      css = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore',
        },
      },
      scss = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore',
        },
      },
      less = {
        validate = true,
        lint = {
          unknownAtRules = 'ignore',
        },
      },
    },
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss' },
    -- Use root_markers for Neovim 0.11+ (replaces root_dir function)
    root_markers = { '.git' },
    single_file_support = true,
  }
end
