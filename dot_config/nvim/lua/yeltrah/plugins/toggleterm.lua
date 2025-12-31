return {
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		cmd = { 'ToggleTerm', 'TermExec' },
		opts = {
			size = function(term)
				if term.direction == 'horizontal' then
					return 15
				elseif term.direction == 'vertical' then
					return vim.o.columns * 0.4
				end
				return 20
			end,
			open_mapping = [[<c-4>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			auto_scroll = true,
			terminal_mappings = true,
			persist_mode = true,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		},
		keys = {
			{ '<leader>tt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
			{ '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Horizontal Terminal' },
			{ '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Vertical Terminal' },
			{ '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Floating Terminal' },
			{ '<leader>tg', function() 
				local Terminal = require('toggleterm.terminal').Terminal
				local lazygit = Terminal:new({ cmd = 'lazygit', direction = 'float', hidden = true })
				lazygit:toggle()
			end, desc = 'Lazygit' },
			{ '<leader>tn', function()
				local Terminal = require('toggleterm.terminal').Terminal
				local node = Terminal:new({ cmd = 'node', direction = 'float', hidden = true })
				node:toggle()
			end, desc = 'Node REPL' },
			{ '<leader>tp', function()
				local Terminal = require('toggleterm.terminal').Terminal
				local python = Terminal:new({ cmd = 'python3', direction = 'float', hidden = true })
				python:toggle()
			end, desc = 'Python REPL' },
		},
	}
}