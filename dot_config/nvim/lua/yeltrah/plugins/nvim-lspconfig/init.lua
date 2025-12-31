local settings = require('yeltrah.settings')

return {
  {
    -- LSP configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- nvim-cmp source for built-in LSP client
      'hrsh7th/cmp-nvim-lsp',

      -- Document symbol visibility
      'SmiteshP/nvim-navbuddy',

      {
        'nvimdev/lspsaga.nvim',
        event = 'LspAttach',
        dependencies = {
          'nvim-treesitter/nvim-treesitter', -- optional
          'nvim-tree/nvim-web-devicons', -- optional
        },
        config = function()
          local ok, lspsaga = pcall(require, 'lspsaga')
          if ok then
            lspsaga.setup({
              ui = {
                border = settings.border,
                winblend = 10,
              },
            })
          end
        end,
      },

      -- Useful status updates for LSP
      {
        'j-hui/fidget.nvim',
        cond = function()
          return settings.fidget
        end,
        opts = {
          notification = {
            window = {
              winblend = 0,
            },
          },
        },
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            -- Load nvim-dap-ui types
            { path = 'nvim-dap-ui', words = { 'dapui' } },
          },
        },
      },

      -- Schema store
      'b0o/schemastore.nvim',

      -- Preview LSP results in buffer
      {
        'rmagatti/goto-preview',
        dependencies = {
          'nvim-telescope/telescope.nvim', -- Used and configued in telescope
        },
        config = function()
          require('goto-preview').setup({
            references = {
              telescope = require('telescope.config').values,
            },
            post_open_hook = function()
              -- add preview window to buffer list
              local buffer_num = vim.api.nvim_get_current_buf() -- current buffer
              vim.bo[buffer_num].buflisted = true
            end,
          })
        end,
      },
    },
    config = function()
      require('yeltrah.plugins.nvim-lspconfig.ui')
      require('yeltrah.plugins.nvim-lspconfig.lsp')
      require('yeltrah.plugins.nvim-lspconfig.autoformat')
    end,
  },
}
