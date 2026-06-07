return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/schemastore.nvim",
    { "folke/lazydev.nvim", ft = "lua", opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "nvim-dap-ui", words = { "dapui" } },
        },
    } },
  },
  config = function()
    -- Global defaults applied to every server (blink injects capabilities).
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    -- Force utf-16 to avoid multi-server offset-encoding warnings (ruff + basedpyright).
    capabilities.general = capabilities.general or {}
    capabilities.general.positionEncodings = { "utf-16" }
    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git" },
    })

    -- Diagnostics UI (sign-define removed in 0.12 -> use vim.diagnostic.config)
    vim.diagnostic.config({
      virtual_text = false, -- tiny-inline-diagnostic owns this (Phase 11)
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = { border = "rounded", source = true },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.INFO]  = "",
          [vim.diagnostic.severity.HINT]  = "",
        },
      },
    })

    -- LSP keymaps on attach (telescope -> Snacks.picker; same letters as before)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
      callback = function(event)
        local bufnr = event.buf
        local map = function(keys, fn, desc, mode)
          vim.keymap.set(mode or "n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        map("gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("gr", function() Snacks.picker.lsp_references() end, "References")
        map("gi", function() Snacks.picker.lsp_implementations() end, "Implementation")
        map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type Definition")
        map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "Document Symbols")
        map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")
        map("gb", function() Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics")
        map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
        map("<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature Help")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("gl", vim.diagnostic.open_float, "Line Diagnostics")
        map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
        map("<leader>q", vim.diagnostic.setloclist, "Diagnostics Loclist")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        end
      end,
    })

    -- Servers we manage. mason installs them; we enable ONLY these
    -- (automatic_enable off) so leftover mason packages from older configs
    -- (ts_ls, stylua-as-lsp, omnisharp, vue, prisma, ...) never auto-attach.
    -- vtsls is the sole TypeScript server.
    local servers = {
      "lua_ls", "basedpyright", "ruff", "vtsls", "eslint", "tailwindcss",
      "cssls", "bashls", "intelephense", "jsonls", "yamlls", "gopls",
      "rust_analyzer", "terraformls", "tflint", "dockerls", "html",
      "graphql", "vimls",
    }
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_enable = false,
    })
    vim.lsp.enable(servers)
    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua", "prettier", "shfmt", "eslint_d", "shellcheck", "markdownlint", "hadolint",
      },
    })
  end,
}
