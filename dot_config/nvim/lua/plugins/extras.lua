return {
  -- Keybinding popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Keymaps (which-key)" },
    },
  },

  -- Add/change/delete surrounding pairs.
  -- v4 creates keymaps in plugin/ (gated by vim.g flags), NOT via setup(). Disable
  -- the default visual S/gS in `init` (runs BEFORE the plugin loads) so flash keeps
  -- visual `S`, then bind surround's visual to gs/gS in config.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      vim.g.nvim_surround_no_visual_mappings = true
    end,
    config = function()
      require("nvim-surround").setup({})
      vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)", { desc = "Surround selection" })
      vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", { desc = "Surround selection (line)" })
    end,
  },

  -- Highlight + search TODO/FIX/HACK/NOTE
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todos (Trouble)" },
    },
  },

  -- Code outline / symbols
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = { default_direction = "right" },
    },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Outline (Aerial)" },
    },
  },

  -- Pretty in-buffer markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Rich git diff / file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (this file)" },
      { "<leader>gF", "<cmd>DiffviewFileHistory<cr>", desc = "File History (repo)" },
    },
  },

  -- Session restore per cwd
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>ps", function() require("persistence").load() end, desc = "Restore Session (cwd)" },
      { "<leader>pl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>pd", function() require("persistence").stop() end, desc = "Stop Saving Session" },
    },
  },

  -- Test runner UI (Python/TS/Go), debugs through nvim-dap
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
      "fredrikaverpil/neotest-golang",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-vitest"),
          require("neotest-golang"),
        },
      })
    end,
    keys = {
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Test Nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test File" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test Last" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test Stop" },
      { "<leader>tD", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch Test File" },
    },
  },
}
