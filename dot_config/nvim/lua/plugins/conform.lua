return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format buffer",
      },
      {
        "<leader>ft",
        function()
          vim.g.conform_format_on_save = not vim.g.conform_format_on_save
          print("Format on save: " .. (vim.g.conform_format_on_save and "enabled" or "disabled"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
      },
      format_on_save = function(bufnr)
        if vim.g.conform_format_on_save == false then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        clang_format = {
          prepend_args = { "--style", "webkit" },
        },
      },
    },
    init = function()
      vim.g.conform_format_on_save = true
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
