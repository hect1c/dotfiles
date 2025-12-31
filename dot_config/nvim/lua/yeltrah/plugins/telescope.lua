local Remap = require('yeltrah.config.keymaps.bindings')
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')
      local lga_actions = require('telescope-live-grep-args.actions')
      local lga_shortcuts = require('telescope-live-grep-args.shortcuts')

      -- Scroll preview one line at a time
      -- https://github.com/nvim-telescope/telescope.nvim/issues/2602#issuecomment-1636809235
      local state = require('telescope.state')
      local action_state = require('telescope.actions.state')

      local slow_scroll = function(prompt_bufnr, direction)
        local previewer = action_state.get_current_picker(prompt_bufnr).previewer
        local status = state.get_status(prompt_bufnr)

        -- Check if we actually have a previewer and a preview window
        if type(previewer) ~= 'table' or previewer.scroll_fn == nil or status.preview_win == nil then
          return
        end

        previewer:scroll_fn(1 * direction)
      end

      telescope.setup({
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            width = 0.95,
            height = 0.85,
            prompt_position = 'top',
            preview_width = 0.6,
            horizontal = {
              preview_width = 0.6,
            },
            vertical = {
              width = 0.9,
              height = 0.95,
              preview_height = 0.5,
            },
          },
          scroll_strategy = 'limit',
          path_display = { 'truncate' },
          sorting_strategy = 'ascending',
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
          prompt_prefix = ' ',
          selection_caret = ' ',
          entry_prefix = '  ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.DS_Store",
            "%.pyc",
            "__pycache__/",
            "%.lock",
          },
          color_devicons = true,
          use_less = true,
          set_env = { ['COLORTERM'] = 'truecolor' },
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
          mappings = {
            i = {
              ['<C-f>'] = function(bufnr)
                slow_scroll(bufnr, 1)
              end,
              ['<C-b>'] = function(bufnr)
                slow_scroll(bufnr, -1)
              end,
            },
          },
        },
        pickers = {
          buffers = {
            sort_lastused = true,
            mappings = {
              i = {
                ['<C-g>'] = actions.delete_buffer,
              },
            },
          },
          diagnostics = { layout_strategy = 'vertical' },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ['<C-k>'] = lga_actions.quote_prompt(),
              },
            },
          },
        },
      })

      -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, 'fzf')

      -- Enable telescope-ui-select, if installed
      pcall(telescope.load_extension, 'ui-select')

      -- Enable persisted, if installed
      pcall(telescope.load_extension, 'persisted')

      -- Enable project, if installed
      pcall(telescope.load_extension, 'projects')

      -- Keymaps
      nnoremap('<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
      nnoremap('<leader>//', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
      nnoremap('<leader>pa', function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
          no_parent_ignore = true,
        })
      end, { desc = '[S]earch [A]ll Files' })
      nnoremap('<leader>pf', builtin.find_files, { desc = '[S]earch [F]iles' })
      nnoremap('<leader>pg', builtin.git_files, { desc = '[S]earch [G]it Files' })
      nnoremap('<leader>pb', builtin.buffers, { desc = '[S]earch [B]uffers' })
      nnoremap('<leader>ph', builtin.help_tags, { desc = '[S]earch [H]elp' })
      nnoremap('<leader>pd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      nnoremap('<leader>pr', builtin.resume, { desc = '[S]earch [R]esume' })
      nnoremap('<leader>pk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      nnoremap('<leader>pc', builtin.commands, { desc = '[S]earch [C]ommands' })

      -- Enable telescope live grep args, if installed
      local ok = pcall(telescope.load_extension, 'live_grep_args')
      if ok then
        nnoremap('<leader>pss', telescope.extensions.live_grep_args.live_grep_args, { desc = '[S]earch [S]omething' })
        nnoremap('<leader>psw', lga_shortcuts.grep_word_under_cursor, { desc = '[S]earch current [W]ord' })
        vnoremap('<leader>psv', lga_shortcuts.grep_visual_selection, { desc = '[S]earch [V]isual selection' })
      else
        nnoremap('<leader>psw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        nnoremap('<leader>pss', builtin.live_grep, { desc = '[S]earch [S]omething' })
      end

      -- Enable harpoon, if installed
      ok = pcall(telescope.load_extension, 'harpoon')
      if ok then
        nnoremap('<leader>hs', '<cmd>Telescope harpoon marks<CR>', { desc = '[H]arpoon [S]earch Files' })
      end
    end,
  },
}
