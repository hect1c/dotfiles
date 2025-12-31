return {
  {
    'romgrk/barbar.nvim',
    event = { 'BufEnter' },
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = true,
      auto_hide = false,
      tabpages = true,
      maximum_padding = 4,
      icons = {
        button = '',
        buffer_index = false,
        buffer_number = false,
        filetype = { enabled = true },
      },
      exclude_ft = { 'triptych' },
      exclude_name = { 'Triptych' },
    },
  },
}
