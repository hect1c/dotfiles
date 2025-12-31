return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      filetypes = {
        'lua',
        'vim',
      },
    })
  end,
}