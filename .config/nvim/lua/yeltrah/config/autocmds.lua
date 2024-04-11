local augroup = vim.api.nvim_create_augroup
YeltrahGroup = augroup("Yeltrah", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
	group = YeltrahGroup,
	pattern = "*.rs",
	callback = function()
		require("lsp_extensions").inlay_hints({})
	end,
})

autocmd({ "BufWritePre" }, {
	group = YeltrahGroup,
	pattern = "*",
	command = "%s/\\s\\+$//e",
})
