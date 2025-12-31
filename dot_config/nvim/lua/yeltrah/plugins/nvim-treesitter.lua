return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))

      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'lua',
          'python',
          'javascript',
          'gitignore',
          'typescript',
          'vimdoc',
          'vim',
          'bash',
          'json',
          'yaml',
          'markdown',
          'markdown_inline',
          'graphql',
          'html',
          'toml',
          'css',
        },
        diagnostics = { disable = { 'missing-fields' } },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        -- nvim-ts-autotag
        autotag = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<M-space>',
          },
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        ignore_install = { '' }, -- List of parsers to ignore installing
        autopairs = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['af'] = '@function.outer',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
              ['ab'] = '@block.outer',
              ['ib'] = '@block.inner',
            },
            -- You can choose the select mode (default is charwise 'v')
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V', -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding xor succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
        },
      })

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }

      vim.opt.foldlevel = 99
      vim.opt.foldmethod = 'indent'
      vim.opt.foldenable = true

      -- Highlight
      local function update_hl(group, tbl)
        local old_hl = vim.api.nvim_get_hl(0, { name = group })
        local new_hl = vim.tbl_extend('force', old_hl, tbl)
        vim.api.nvim_set_hl(0, group, new_hl)
      end

      update_hl('Comment', { italic = true })
      update_hl('Constant', { italic = true })
      update_hl('Keyword', { italic = true })
    end,
  },
}
