return {
  {
    'simonmclean/triptych.nvim',
    cmd = 'Triptych',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>e',
        '<cmd>Triptych<CR>',
        desc = 'Toggle Triptych',
      },
    },
    init = function()
      -- Auto-open Triptych when vim starts with a directory
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function(data)
          -- Buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          if not directory then
            return
          end

          -- Change to the directory
          vim.cmd.cd(data.file)

          -- Open triptych using command (triggers lazy loading)
          vim.cmd('Triptych')
        end,
      })
    end,
    config = function()
      require('triptych').setup({
        -- Responsive column widths based on terminal size
        mappings = {
          -- Navigation
          show_help = 'g?',
          jump_to_cwd = '.',
          nav_left = 'h',
          nav_right = { 'l', '<CR>' },
          open_hsplit = { '-' },
          open_vsplit = { '|', 'v' },
          open_tab = { '<C-t>' },
          cd = '<leader>cd',
          delete = 'd',
          add = 'a',
          copy = 'c',
          rename = 'r',
          cut = 'x',
          paste = 'p',
          quit = 'q',
          toggle_hidden = '<leader>.',
        },
        extension_mappings = {},
        options = {
          dirs_first = true,
          show_hidden = false,
          line_numbers = {
            enabled = true,
            relative = false,
          },
          file_icons = {
            enabled = true,
            directory_icon = '',
            fallback_file_icon = '',
          },
          responsive_column_widths = {
            -- Keys are breakpoints, values are column widths
            -- A breakpoint means "when terminal width is greater than this"
            ['0'] = { 0.15, 0.35, 0.5 },
            ['120'] = { 0.2, 0.3, 0.5 },
            ['200'] = { 0.25, 0.25, 0.5 },
          },
          highlights = {
            file_names = 'NONE',
            directory_names = 'NONE',
          },
          syntax_highlighting = {
            enabled = true,
            debounce_ms = 100,
          },
          backdrop = 60,
        },
        git_signs = {
          enabled = true,
          signs = {
            add = '+',
            modify = '~',
            rename = 'r',
            untracked = '?',
          },
        },
        diagnostic_signs = {
          enabled = true,
        },
      })
    end,
  },
}
