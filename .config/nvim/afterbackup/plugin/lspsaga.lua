local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

saga.setup({
	ui = { winblend = 10, border = "rounded", colors = { normal_bg = "#002b36" } },
})

-- local diagnostic = require("lspsaga.diagnostic")
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "gl", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts)
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "gd", "<Cmd>Lspsaga finder<CR>", opts)
-- vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', opts)
vim.keymap.set("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
vim.keymap.set("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
vim.keymap.set("n", "gc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
vim.keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer

-- code action
local codeaction = require("lspsaga.codeaction")
vim.keymap.set("n", "<leader>ca", function()
	codeaction:code_action()
end, { silent = true })
vim.keymap.set("v", "<leader>ca", function()
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-U>", true, false, true))
	codeaction:range_code_action()
end, { silent = true })
