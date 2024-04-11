local settings = require("yeltrah.settings")

return {
	{
		-- LSP configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- nvim-cmp source for built-in LSP client
			"hrsh7th/cmp-nvim-lsp",

			-- Document symbol visibility
			"SmiteshP/nvim-navbuddy",

			{
				"nvimdev/lspsaga.nvim",
				event = "LspAttach",
				config = function()
					return require("lspsaga").setup({
						ui = {
							winblend = 10,
							border = settings.border,
							colors = {
								normal_bg = "#002b36",
							},
							kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
						},
					})
				end,
				dependencies = {
					"nvim-treesitter/nvim-treesitter", -- optional
					"nvim-tree/nvim-web-devicons", -- optional
				},
				opts = {
					ui = {
						border = settings.border,
					},
					outline = {
						layout = "float",
					},
				},
			},

			-- Useful status updates for LSP
			{
				"j-hui/fidget.nvim",
				tag = "legacy",
				cond = function()
					return settings.fidget
				end,
				opts = {
					window = {
						blend = 0,
					},
				},
			},

			-- Additional lua configuration, makes nvim stuff amazing!
			{
				"folke/neodev.nvim",
				ft = "lua",
				opts = { pathStrict = true, library = { plugins = { "nvim-dap-ui" }, types = true } },
			},

			-- Schema store
			"b0o/schemastore.nvim",

			-- Preview LSP results in buffer
			{
				"rmagatti/goto-preview",
				dependencies = {
					"nvim-telescope/telescope.nvim", -- Used and configued in telescope
				},
				config = function()
					require("goto-preview").setup({
						references = {
							telescope = require("telescope.config").values,
						},
						post_open_hook = function()
							-- add preview window to buffer list
							local buffer_num = vim.api.nvim_get_current_buf() -- current buffer
							vim.api.nvim_buf_set_option(buffer_num, "buflisted", true)
						end,
					})
				end,
			},
		},
		config = function()
			require("yeltrah.plugins.nvim-lspconfig.ui")
			require("yeltrah.plugins.nvim-lspconfig.lsp")
			require("yeltrah.plugins.nvim-lspconfig.autoformat")
		end,
	},
}
