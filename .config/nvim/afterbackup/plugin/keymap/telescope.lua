local Remap = require("yeltrah.keymaps")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope")

nnoremap("<leader>ps", ":Telescope live_grep<CR>")

nnoremap("<C-p>", function()
  require("telescope.builtin").git_files()
end)
nnoremap("<leader>pf", function()
  require("telescope.builtin").find_files({
    hidden = true,
  })
end)

nnoremap("<leader>pw", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end)
nnoremap("<leader>pb", function()
  require("telescope.builtin").buffers()
end)
nnoremap("<leader>vh", function()
  require("telescope.builtin").help_tags()
end)

-- TODO: Fix this immediately
nnoremap("<leader>vwh", function()
  require("telescope.builtin").help_tags()
end)
