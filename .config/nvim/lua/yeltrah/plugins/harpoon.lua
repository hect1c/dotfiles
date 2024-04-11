local Remap = require("yeltrah.config.keymaps.bindings")
local nnoremap = Remap.nnoremap

return {
  {
    -- Faster file navigation
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')
      nnoremap('<leader>ha', mark.add_file, { desc = '[H]arpoon [A]dd file' })
      nnoremap('<leader>hu', ui.toggle_quick_menu, { desc = '[H]arpoon [U]I' })
      for id = 1, 5 do
        nnoremap('<leader>h' .. id, function()
          ui.nav_file(id)
        end, { desc = '[H]arpoon File [' .. id .. ']' })
      end
    end,
  },
}