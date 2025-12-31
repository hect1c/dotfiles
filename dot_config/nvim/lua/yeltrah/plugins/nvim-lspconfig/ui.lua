local border = require('yeltrah.settings').border

-- Documentation and Signature Help borders configured via vim.lsp.config
vim.lsp.config('*', {
  handlers = {
    ['textDocument/hover'] = function(...)
      local bufnr, winnr = vim.lsp.util.open_floating_preview(...)
      if winnr then
        vim.api.nvim_win_set_config(winnr, { border = border })
      end
      return bufnr, winnr
    end,
    ['textDocument/signatureHelp'] = function(...)
      local bufnr, winnr = vim.lsp.util.open_floating_preview(...)
      if winnr then
        vim.api.nvim_win_set_config(winnr, { border = border })
      end
      return bufnr, winnr
    end,
  },
})

-- Diagnostic configuration moved to vim.diagnostic.config below

-- Diagnostic configuration
vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		prefix = "●",
		severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
	},
	severity_sort = true,
	float = {
		source = "if_many",
		header = "",
		prefix = "",
		border = border,
		focusable = false,
		severity = { min = vim.diagnostic.severity.HINT }, -- Show all levels in float
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT }, -- Show all levels in signs
		text = {
			[vim.diagnostic.severity.ERROR] = "✘ ",
			[vim.diagnostic.severity.WARN] = "▲ ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
			[vim.diagnostic.severity.INFO] = "● ",
		},
	},
})


require('lspconfig.ui.windows').default_options = {
  border = border,
}