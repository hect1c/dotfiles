return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "frappe",
    background = { dark = "frappe" },
    transparent_background = true,
    term_colors = true,
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      snacks = true,
      treesitter = true,
      native_lsp = { enabled = true },
      harpoon = true,
      which_key = true,
      mason = true,
      barbar = true,
      dap = true,
      dap_ui = true,
    },
    custom_highlights = function(colors)
      return {
        LineNr = { fg = colors.overlay0 },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
