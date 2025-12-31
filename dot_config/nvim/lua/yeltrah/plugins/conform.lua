return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
      {
        '<leader>ft',
        function()
          vim.g.conform_format_on_save = not vim.g.conform_format_on_save
          print('Format on save: ' .. (vim.g.conform_format_on_save and 'enabled' or 'disabled'))
        end,
        desc = 'Toggle format on save',
      },
    },
    opts = {
      formatters_by_ft = {
        -- Use ruff for Python (combines formatting and import sorting)
        python = { 'ruff_format', 'ruff_organize_imports' },
        
        -- Web development
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        
        -- Lua
        lua = { 'stylua' },
        
        -- Shell
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        zsh = { 'shfmt' },
        
        -- C/C++
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        
        -- Terraform
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        
        -- Go
        go = { 'goimports', 'gofmt' },
        
        -- Rust (handled by LSP usually, but as fallback)
        rust = { 'rustfmt' },
      },
      
      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Disable format on save if global toggle is off
        if vim.g.conform_format_on_save == false then
          return
        end
        
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match('/node_modules/') then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      
      -- Custom formatters (if needed)
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
        clang_format = {
          prepend_args = { '--style', 'webkit' },
        },
      },
    },
    init = function()
      -- Initialize format on save as enabled
      vim.g.conform_format_on_save = true
      
      -- If you want even better performance, you can use this
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}