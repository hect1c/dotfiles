local settings = require('yeltrah.settings')

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>C', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gpc', require('goto-preview').close_all_win, '[C]lose All [P]review Windows')
  nmap('gpC', function()
    require('goto-preview').close_all_win({ skip_curr_window = true })
  end, '[C]lose All [P]review Windows Except Current')

  nmap('gd', function()
    require('telescope.builtin').lsp_definitions({ show_line = false })
  end, '[G]oto [D]efinition')
  nmap('gpd', require('goto-preview').goto_preview_definition, '[P]review [D]efinition')

  nmap('gr', function()
    require('telescope.builtin').lsp_references({ show_line = false })
  end, '[G]oto [R]eferences')
  nmap('gpr', require('goto-preview').goto_preview_references, '[P]review [R]eferences')

  nmap('gi', function()
    require('telescope.builtin').lsp_implementations({ show_line = false })
  end, '[G]oto [I]mplementation')
  nmap('gpi', require('goto-preview').goto_preview_implementation, '[P]review [I]mplementation')

  nmap('<leader>D', function()
    require('telescope.builtin').lsp_type_definitions({ show_line = false })
  end, 'Type [D]efinition')
  nmap('gpD', require('goto-preview').goto_preview_type_definition, '[P]review Type [D]efinition')

  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('gl', '<Cmd>Lspsaga show_line_diagnostics<CR>', 'Show Line Diagnostics')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gpD', require('goto-preview').goto_preview_declaration, '[P]review [D]eclaration')

  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navbuddy').attach(client, bufnr)
  end
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- Setup mason so it can manage external tooling
require('mason').setup({
  ui = {
    border = settings.border,
  },
})

require('mason-lspconfig').setup({
  ensure_installed = {
    'bashls',
    'gopls',
    'jsonls',
    'lua_ls',
    'marksman',
    'pyright',
    'rust_analyzer',
    'tsserver',
    'vimls',
    'yamlls',
    'tflint',
    'eslint',
    'graphql',
    'terraformls',
    'cssls',
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

local lsp_defaults = {
  capabilities = capabilities,
  on_attach = on_attach,
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend('force', lspconfig.util.default_config, lsp_defaults)

lspconfig.bashls.setup({
  filetypes = { 'sh', 'zsh' },
})

lspconfig.gopls.setup({})

lspconfig.jsonls.setup({
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

lspconfig.marksman.setup({})

lspconfig.pyright.setup({})

lspconfig.rust_analyzer.setup({})

lspconfig.tsserver.setup({})

lspconfig.vimls.setup({})

lspconfig.yamlls.setup({
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      schemaStore = {
        enable = false,
      },
      keyOrdering = false,
    },
  },
})

lspconfig.tflint.setup({})

lspconfig.eslint.setup({})

lspconfig.graphql.setup({})

lspconfig.terraformls.setup({})

lspconfig.cssls.setup({})
