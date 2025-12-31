return {
	{
		-- NOTE: Replaced with conform.nvim for formatting
		-- Keeping for linting diagnostics only
		"jay-babu/mason-null-ls.nvim",
		enabled = false, -- Disabled in favor of conform.nvim
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim", -- Used and configured in nvim-lspconfig.lua
			{
				"nvimtools/none-ls.nvim",
				lazy = false, -- Load immediately to avoid module not found errors
				priority = 1000,
				dependencies = {
					"nvimtools/none-ls-extras.nvim",
				},
			},
		},
		config = function()
			require("mason").setup()
			
			-- Set up none-ls with proper error handling
			local ok, none_ls = pcall(require, "none-ls")
			if ok then
				local formatting = none_ls.builtins.formatting
				local diagnostics = none_ls.builtins.diagnostics
				local code_actions = none_ls.builtins.code_actions
				
				-- Create sources list with proper error handling for extras
				local sources = {
					-- Basic formatting sources
					formatting.stylua,
					formatting.prettierd,
					formatting.clang_format.with({
						extra_args = { "--style", "webkit" },
					}),
					formatting.shfmt.with({
						filetypes = { "sh", "zsh" },
					}),
					formatting.terraform_fmt,
					
					-- Basic diagnostic sources
					diagnostics.zsh.with({
						filetypes = { "zsh" },
					}),
				}
				
				-- Add ruff sources if available
				local ruff_ok, ruff_formatting = pcall(require, "none-ls.formatting.ruff")
				if ruff_ok then
					table.insert(sources, ruff_formatting.with({
						extra_args = { "--select", "I,E,F", "--fix" },
					}))
				else
					-- Fallback to basic ruff if available
					if formatting.ruff then
						table.insert(sources, formatting.ruff)
					end
				end
				
				local ruff_diag_ok, ruff_diagnostics = pcall(require, "none-ls.diagnostics.ruff")
				if ruff_diag_ok then
					table.insert(sources, ruff_diagnostics.with({
						diagnostics_format = "[ruff] #{m} (#{c})",
					}))
				end
				
				-- Add eslint sources if available
				local eslint_diag_ok, eslint_diagnostics = pcall(require, "none-ls.diagnostics.eslint_d")
				if eslint_diag_ok then
					table.insert(sources, eslint_diagnostics.with({
						diagnostics_format = "[eslint] #{m}\n(#{c})",
						condition = function(utils)
							return utils.root_has_file(".eslintrc.js")
						end,
					}))
				end
				
				local eslint_ca_ok, eslint_code_actions = pcall(require, "none-ls.code_actions.eslint_d")
				if eslint_ca_ok then
					table.insert(sources, eslint_code_actions)
				end

				none_ls.setup({
					border = require("yeltrah.settings").border,
					sources = sources,
					debug = false, -- Set to true for debugging
				})
				
				vim.notify("none-ls configured with " .. #sources .. " sources", vim.log.levels.INFO)
			else
				vim.notify("Failed to load none-ls: " .. tostring(none_ls), vim.log.levels.ERROR)
			end
			
			-- Always run mason-null-ls setup regardless of none-ls status
			require("mason-null-ls").setup({
				ensure_installed = nil,
				automatic_installation = true,
			})
		end,
	},
}
