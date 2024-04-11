local status3, lsp_zero = pcall(require, "lsp-zero")
if not status3 then
	return
end

local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end
local null_opts = lsp_zero.build_options("null-ls", {})
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

-- Never request typescript-language-server for formatting
vim.lsp.buf.format({
	filter = function(client)
		return client.name ~= "tsserver"
	end,
})

local sources = {
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.diagnostics.eslint_d.with({
		diagnostics_format = "[eslint] #{m}\n(#{c})",
		-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
		condition = function(utils)
			return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
		end,
	}),
	null_ls.builtins.diagnostics.pylint.with({
		diagnostics_postprocess = function(diagnostic)
			diagnostic.code = diagnostic.message_id
		end,
	}),
	null_ls.builtins.formatting.isort,
	null_ls.builtins.formatting.black,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.code_actions.eslint_d,
	null_ls.builtins.formatting.terraform_fmt,
}

-- Check if .editorconfig exists in the project root
-- local editorconfig_exists = require("plenary.path"):new(vim.fn.getcwd() .. "/.editorconfig"):exists()
--
-- -- Use prettier_d if .editorconfig exists
-- if editorconfig_exists then
-- 	table.insert(sources, {
-- 		method = null_ls.methods.FORMATTING,
-- 		filetypes = { "javascript", "typescript" }, -- specify your filetypes
-- 		generator = {
-- 			command = "prettier_d",
-- 			args = { "--stdin-filepath", "$FILENAME" },
-- 			to_stdin = true,
-- 		},
-- 	})
-- else
-- 	-- Your usual setup without .editorconfig
-- ,end

null_ls.setup({
	debug = false,
	sources = sources,
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
})

vim.api.nvim_create_user_command("DisableLspFormatting", function()
	vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
end, { nargs = 0 })

local null_ls_stop = function()
	local null_ls_client
	for _, client in ipairs(vim.lsp.get_active_clients()) do
		if client.name == "null-ls" then
			null_ls_client = client
		end
	end
	if not null_ls_client then
		return
	end

	null_ls_client.stop()
end

vim.api.nvim_create_user_command("NullLsStop", null_ls_stop, {})

vim.api.nvim_create_user_command("NullLsToggle", function()
	-- you can also create commands to disable or enable sources
	require("null-ls").toggle({})
end, {})

-- require("mason-null-ls").setup_handlers() -- If `automatic_setup` is true.
