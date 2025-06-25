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
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- Setup mason so it can manage external tooling
require('mason').setup({
  ui = {
    border = settings.border,
  },
})

local servers = {
  bashls = require('yeltrah.plugins.nvim-lspconfig.servers.bashls')(on_attach),
  cssls = require('yeltrah.plugins.nvim-lspconfig.servers.cssls')(on_attach),
  dockerls = {},
  html = {},
  jsonls = {},
  lua_ls = require('yeltrah.plugins.nvim-lspconfig.servers.luals')(on_attach),
  intelephense = require('yeltrah.plugins.nvim-lspconfig.servers.phpls')(on_attach),
  pylsp = {},
  gopls = {},
  rust_analyzer = {},
  tailwindcss = require('yeltrah.plugins.nvim-lspconfig.servers.tailwindcss')(on_attach),
  terraformls = {},
  tflint = {},
  eslint = require('yeltrah.plugins.nvim-lspconfig.servers.eslint')(on_attach),
  graphql = {},
  vimls = {},
  ts_ls = require('yeltrah.plugins.nvim-lspconfig.servers.ts_ls')(on_attach),
  yamlls = {},
}

local server_names = {}
local server_configs = {}
for server_name, server_config in pairs(servers) do
  table.insert(server_names, server_name)
  server_configs[server_name] = server_config
end

local lsp_defaults = {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
}

local lspconfig = require('lspconfig')

require('mason-lspconfig').setup({
  ensure_installed = server_names,
  automatic_installation = false,
  automatic_enable = false,
})

-- Setup servers manually since setup_handlers is removed in v2.0+
for server_name, server_config in pairs(servers) do
  local merged_config = vim.tbl_deep_extend('force', lsp_defaults, server_config or {})
  lspconfig[server_name].setup(merged_config)
  
  if server_name == 'rust_analyzer' then
    local present_rust_tools, rust_tools = pcall(require, 'rust-tools')
    if present_rust_tools then
      rust_tools.setup({ server = merged_config })
    end
  end
end

lspconfig.util.default_config = vim.tbl_deep_extend('force', lspconfig.util.default_config, lsp_defaults)

lspconfig.cssls.setup({})
