return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      local ensure = {
        "lua", "vim", "vimdoc", "query", "bash", "python", "javascript",
        "typescript", "tsx", "json", "yaml", "toml", "html", "css",
        "scss", "go", "rust", "php", "terraform", "hcl", "dockerfile",
        "graphql", "markdown", "markdown_inline", "gitcommit", "gitignore",
        "diff", "regex",
      }
      require("nvim-treesitter").install(ensure)

      -- jsonc has no dedicated parser on the main-branch registry; reuse json.
      vim.treesitter.language.register("json", "jsonc")

      -- Start highlighting + treesitter-based indent/fold per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local started = pcall(vim.treesitter.start, ev.buf)
          if started then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
          local ok = pcall(vim.treesitter.query.get, vim.bo[ev.buf].filetype, "indents")
          if ok then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Keep folds open by default (was foldlevel=99 in old config).
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Italic comments/constants/keywords (ported from old config), resilient
      -- to colorscheme reloads.
      local function set_italics()
        local function update_hl(group, tbl)
          local hl = vim.api.nvim_get_hl(0, { name = group })
          vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, tbl))
        end
        update_hl("Comment", { italic = true })
        update_hl("Constant", { italic = true })
        update_hl("Keyword", { italic = true })
      end
      set_italics()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_italics })

      -- Incremental selection (main branch removed the module; minimal reimpl).
      local sel_stack = {}
      local function update_visual(node)
        local srow, scol, erow, ecol = node:range()
        if ecol == 0 and erow > srow then
          erow = erow - 1
          ecol = math.max(vim.fn.col({ erow + 1, "$" }) - 1, 1)
        end
        local end_col = math.max(ecol - 1, 0)
        if vim.fn.mode():match("[vV\22]") then
          vim.cmd("normal! \27")
        end
        vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { erow + 1, end_col })
      end
      local function ts_init()
        local node = vim.treesitter.get_node()
        if not node then return end
        sel_stack = { node }
        update_visual(node)
      end
      local function ts_grow()
        if #sel_stack == 0 then return ts_init() end
        local cur = sel_stack[#sel_stack]
        local parent = cur:parent()
        while parent and vim.deep_equal({ parent:range() }, { cur:range() }) do
          parent = parent:parent()
        end
        if not parent then update_visual(cur); return end
        sel_stack[#sel_stack + 1] = parent
        update_visual(parent)
      end
      local function ts_shrink()
        if #sel_stack > 1 then sel_stack[#sel_stack] = nil end
        local node = sel_stack[#sel_stack]
        if node then update_visual(node) end
      end
      vim.keymap.set("n", "<C-space>", ts_init, { desc = "TS init selection" })
      vim.keymap.set("x", "<C-space>", ts_grow, { desc = "TS grow selection" })
      vim.keymap.set("x", "<M-space>", ts_shrink, { desc = "TS shrink selection" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { max_lines = 3 },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      -- Select
      local sel = require("nvim-treesitter-textobjects.select").select_textobject
      local function smap(lhs, obj)
        vim.keymap.set({ "x", "o" }, lhs, function() sel(obj, "textobjects") end)
      end
      smap("af", "@function.outer")
      smap("if", "@function.inner")
      smap("ac", "@class.outer")
      smap("ic", "@class.inner")
      smap("aa", "@parameter.outer")
      smap("ia", "@parameter.inner")
      smap("al", "@loop.outer")
      smap("il", "@loop.inner")
      smap("ab", "@block.outer")
      smap("ib", "@block.inner")

      -- Move
      local move = require("nvim-treesitter-textobjects.move")
      local function mmap(lhs, fn, obj)
        vim.keymap.set({ "n", "x", "o" }, lhs, function() fn(obj, "textobjects") end)
      end
      mmap("]m", move.goto_next_start, "@function.outer")
      mmap("]]", move.goto_next_start, "@class.outer")
      mmap("]M", move.goto_next_end, "@function.outer")
      mmap("][", move.goto_next_end, "@class.outer")
      mmap("[m", move.goto_previous_start, "@function.outer")
      mmap("[[", move.goto_previous_start, "@class.outer")
      mmap("[M", move.goto_previous_end, "@function.outer")
      mmap("[]", move.goto_previous_end, "@class.outer")

      -- Swap (remapped from old <leader>a/<leader>A to avoid harpoon collision)
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sa", function() swap.swap_next("@parameter.inner") end, { desc = "Swap param next" })
      vim.keymap.set("n", "<leader>sA", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap param prev" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
