local settings = require('yeltrah.settings')

return {
  -- Colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    lazy = settings.colorscheme ~= 'catppuccin',
    opts = {
      flavour = 'frappe',
      transparent_background = settings.transparent,
      term_colors = true,
      integrations = {
        fidget = true,
        harpoon = true,
        mason = true,
        which_key = true,
        barbar = true,
        indent_blankline = true,
        lsp_saga = true,
        nvimtree = false,
      },
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay0 },
        }
      end,
    },
  },
}
