local status, mason = pcall(require, "mason")
if not status then
	return
end

local status2, lspconfig = pcall(require, "mason-lspconfig")
if not status2 then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

local status3, lsp_zero = pcall(require, "lsp-zero")
if not status3 then
	return
end

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

mason.setup({})

lspconfig.setup({
	automatic_installed = true,
	ensure_installed = {
		"bashls",
		"cssls",
		"eslint",
		"graphql",
		"html",
		"jsonls",
		"lua_ls",
		"tailwindcss",
		"terraformls",
		"tflint",
		"tsserver",
		"volar",
		"prismals",
		"yamlls",
		"pylint",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
	automatic_setup = true, -- Recommended, but optional
})
