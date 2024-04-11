return {
  {
    -- Formatting and linting
    'jay-babu/mason-null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
			'williamboman/mason.nvim', -- Used and configured in nvim-lspconfig.lua
			{
				'nvimtools/none-ls.nvim',
				dependencies = {
					"nvimtools/none-ls-extras.nvim",
				}
			}
		},
    config = function()
      require('mason').setup()
      local null_ls = require('null-ls')
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions
      null_ls.setup({
        border = require('yeltrah.settings').border,
        sources = {
					-- formatting
          formatting.black,
          formatting.stylua,
          formatting.prettierd,
          formatting.clang_format.with({
            extra_args = { '--style', 'webkit' },
          }),
          formatting.shfmt.with({
            filetypes = { 'sh', 'zsh' },
          }),
					formatting.terraform_fmt,

					-- diagnostics
					require("none-ls.diagnostics.eslint_d").with({
						diagnostics_format = "[eslint] #{m}\n(#{c})",
						-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
						condition = function(utils)
							return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
						end,
					}),
					diagnostics.pylint.with({
						diagnostics_postprocess = function(diagnostic)
							diagnostic.code = diagnostic.message_id
						end,
					}),

					-- code actions
					require("none-ls.code_actions.eslint_d"),
        },
      })
      require('mason-null-ls').setup({
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
  },
}