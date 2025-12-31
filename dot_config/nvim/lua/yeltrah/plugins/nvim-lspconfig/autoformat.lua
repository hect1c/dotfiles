-- NOTE: Formatting is now handled by conform.nvim
-- This file provides LSP-specific formatting fallbacks when needed

-- Fallback manual format command for LSP-only formatting
vim.api.nvim_create_user_command('LspFormat', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format with LSP only' })

-- Disable LSP formatting for specific servers where we prefer external formatters
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-format-disable', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    
    -- Disable formatting for these servers (handled by conform.nvim)
    local disable_formatting = {
      'ts_ls',
      'lua_ls', 
      'basedpyright',
      'pyright',
      'ruff',
      'eslint',
    }
    
    if vim.tbl_contains(disable_formatting, client.name) then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})
