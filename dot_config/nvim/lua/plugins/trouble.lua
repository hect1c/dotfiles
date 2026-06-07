return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      auto_resize_height = true,
      show_title = false,
      preview = {
        winblend = 0,
      },
      func_map = {
        pscrollup = "<C-u>",
        pscrolldown = "<C-d>",
      },
      filter = {
        fzf = {
          extra_opts = { "--bind", "ctrl-o:toggle-all,ctrl-l:clear-query" },
        },
      },
    },
  },
}
