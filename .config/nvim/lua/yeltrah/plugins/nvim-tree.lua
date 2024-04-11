local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- open as vsplit on current node
  local function vsplit_preview()
    local node = api.tree.get_node_under_cursor()

    if node.nodes ~= nil then
      -- expand or collapse folder
      api.node.open.edit()
    else
      -- open file as vsplit
      api.node.open.vertical()
    end

    -- Finally refocus on tree if it was lost
    api.tree.focus()
  end

  api.config.mappings.default_on_attach(bufnr)
  -- Mappings migrated from view.mappings.list
  --
  -- custom mappings
  vim.keymap.set('n', 'v', vsplit_preview, opts('Vsplit Preview'))
  vim.keymap.set('n', 'h', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'H', api.tree.collapse_all, opts('Collapse All'))
end

return {
  {
    -- File explorer
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '<leader>e',
        function()
          require('nvim-tree.api').tree.toggle({ focus = true, find_file = true })
        end,
        mode = 'n',
        silent = true,
        desc = 'Toggle NvimTree',
      },
      { '<leader>f', '<cmd>NvimTreeFocus<CR>', desc = 'Focus NvimTree' },
    },
    init = function()
      -- https://github.com/Ultra-Code/awesome-neovim/blob/master/lua/plugins/tree.lua
      local autocmd = vim.api.nvim_create_autocmd

      -- when no file/directory is opened at startup
      -- skip nvim-tree so that dashboard can load
      local cmdline_args = -1
      if vim.fn.argc(cmdline_args) == 0 then
        return
      else
        autocmd({ 'VimEnter' }, {
          -- open nvim-tree for noname buffers and directory
          callback = function(args)
            -- buffer is a [No Name]
            local no_name = args.file == '' and vim.bo[args.buf].buftype == ''
            -- buffer is a directory
            local directory = vim.fn.isdirectory(args.file) == 1

            if not directory and not no_name then
              return
            end

            local api = require('nvim-tree.api')

            if directory then
              -- change to the directory
              vim.cmd.cd(args.file)
              -- open the tree
              api.tree.open()
            else
              -- open the tree, find the file but don't focus it
              api.tree.toggle({ focus = false, find_file = true })
            end
          end,
        })
      end

      -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#workaround-when-using-rmagattiauto-session
      autocmd({ 'BufEnter' }, {
        desc = 'Check if nvim-tree is open when session is restored (via persisted) and refresh it',
        pattern = 'NvimTree*',
        callback = function()
          local api = require('nvim-tree.api')
          local view = require('nvim-tree.view')
          if not view.is_visible() then
            api.tree.open()
          end
        end,
      })

      autocmd({ 'VimResized' }, {
        desc = 'Resize nvim-tree when nvim window is resized',
        group = vim.api.nvim_create_augroup('NvimTreeResize', { clear = true }),
        callback = function()
          local width = get_width()
          vim.cmd('tabdo NvimTreeResize ' .. width)
        end,
      })
    end,
    config = function()
      local get_width = function()
        local width_ratio = 0.25
        return math.floor(vim.opt.columns:get() * width_ratio)
      end

      require('nvim-tree').setup({
        on_attach = on_attach,
        hijack_netrw = true,
        hijack_cursor = true,
        -- hijacks new directory buffers when they are opened (`:e dir`).
        hijack_directories = {
          -- enable the feature. Disable this option if you use vim-dirvish or dirbuf.nvim.
          -- If |hijack_netrw| and |disable_netrw| are `false`, this feature will be disabled.
          enable = true,
          -- opens the tree if the tree was previously closed.
          auto_open = true,
        },
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        filters = { dotfiles = false },
        update_focused_file = {
          enable = true,
          update_cwd = true,
          update_root = true,
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
        },
        view = {
          width = get_width,
          float = {
            enable = false,
            open_win_config = function()
              local height_ratio = 0.85
              local width_ratio = 0.25
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * width_ratio
              local window_h = screen_h * height_ratio
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
              return {
                border = require('yeltrah.settings').border,
                relative = 'editor',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
        },
        renderer = {
          root_folder_modifier = ':t',
          highlight_git = true,
          icons = {
            show = {
              git = false,
            },
            glyphs = {
              default = '',
              symlink = '',
              folder = {
                arrow_open = '',
                arrow_closed = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
                symlink_open = '',
              },
              git = {
                unstaged = '',
                staged = 'S',
                unmerged = '',
                renamed = '➜',
                untracked = 'U',
                deleted = '',
                ignored = '◌',
              },
            },
          },
          full_name = true,
        },
      })
    end,
  },
}
