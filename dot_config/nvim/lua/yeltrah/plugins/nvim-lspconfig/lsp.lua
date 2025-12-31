local settings = require('yeltrah.settings')

--  This function gets run when an LSP connects to a particular buffer.
-- Modern LSP keybindings using LspAttach autocmd (2025 pattern)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('yeltrah-lsp-attach', { clear = true }),
  desc = 'LSP actions',
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    
    -- Skip if client is nil or duplicate
    if not client then
      return
    end
    
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    -- Core LSP navigation (using telescope for better UX)
    map('gd', function()
      require('telescope.builtin').lsp_definitions({ show_line = false, reuse_win = true })
    end, '[G]oto [D]efinition')
    
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    
    map('gr', function()
      require('telescope.builtin').lsp_references({ show_line = false, reuse_win = true })
    end, '[G]oto [R]eferences')
    
    map('gi', function()
      require('telescope.builtin').lsp_implementations({ show_line = false, reuse_win = true })
    end, '[G]oto [I]mplementation')
    
    map('<leader>D', function()
      require('telescope.builtin').lsp_type_definitions({ show_line = false, reuse_win = true })
    end, 'Type [D]efinition')

    -- Documentation and help
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Code actions and editing
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'v' })
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Diagnostics (modern approach)
    map('gl', function()
      local ok = pcall(require, 'lspsaga')
      if ok then
        vim.cmd('Lspsaga show_line_diagnostics')
      else
        vim.diagnostic.open_float()
      end
    end, 'Show line diagnostics')
    map('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')
    map(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
    map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')

    -- Buffer diagnostics with fallback
    map('gb', function()
      local ok = pcall(require, 'lspsaga')
      if ok then
        vim.cmd('Lspsaga show_buf_diagnostics')
      else
        require('telescope.builtin').diagnostics({ bufnr = 0 })
      end
    end, 'Show buffer diagnostics')

    -- Symbols
    map('<leader>ds', function()
      require('telescope.builtin').lsp_document_symbols()
    end, '[D]ocument [S]ymbols')
    
    map('<leader>ws', function()
      require('telescope.builtin').lsp_dynamic_workspace_symbols()
    end, '[W]orkspace [S]ymbols')

    -- Workspace management
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Preview mappings (if goto-preview is available)
    local preview_ok = pcall(require, 'goto-preview')
    if preview_ok then
      map('gpd', function() require('goto-preview').goto_preview_definition() end, '[P]review [D]efinition')
      map('gpr', function() require('goto-preview').goto_preview_references() end, '[P]review [R]eferences')
      map('gpi', function() require('goto-preview').goto_preview_implementation() end, '[P]review [I]mplementation')
      map('gpD', function() require('goto-preview').goto_preview_type_definition() end, '[P]review Type [D]efinition')
      map('gpc', function() require('goto-preview').close_all_win() end, '[C]lose All [P]review Windows')
      map('gpC', function() require('goto-preview').close_all_win({ skip_curr_window = true }) end, '[C]lose All [P]review Windows Except Current')
    end

    -- Attach navbuddy if available
    if client and client.server_capabilities.documentSymbolProvider then
      local navbuddy_ok = pcall(require, 'nvim-navbuddy')
      if navbuddy_ok then
        require('nvim-navbuddy').attach(client, bufnr)
      end
    end
  end,
})

-- Keep minimal on_attach for compatibility
local on_attach = function(client, bufnr)
  -- On_attach is now handled by LspAttach autocmd above
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Set consistent position encoding to prevent warnings when multiple servers attach
-- Using UTF-16 as it's the LSP spec default and mandatory
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { 'utf-16' }

-- Removed lsp-zero for Neovim 0.11 compatibility

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
  basedpyright = require('yeltrah.plugins.nvim-lspconfig.servers.basedpyright')(on_attach),
  ruff = require('yeltrah.plugins.nvim-lspconfig.servers.ruff')(on_attach),
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

require('mason-lspconfig').setup({
  ensure_installed = server_names,
  automatic_installation = false,
})

-- Setup servers using Neovim 0.11+ vim.lsp.config API
for server_name, server_config in pairs(servers) do
  local merged_config = vim.tbl_deep_extend('force', lsp_defaults, server_config or {})

  if server_name == 'rust_analyzer' then
    local present_rust_tools, rust_tools = pcall(require, 'rust-tools')
    if present_rust_tools then
      rust_tools.setup({ server = merged_config })
    else
      -- Override nvim-lspconfig defaults with our config
      vim.lsp.config[server_name] = merged_config
      vim.lsp.enable(server_name)
    end
  else
    -- Override nvim-lspconfig defaults with our config
    vim.lsp.config[server_name] = merged_config
    vim.lsp.enable(server_name)
  end
end
