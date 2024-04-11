local opts = { noremap = true, silent = true }
local Remap = require("yeltrah.keymaps")
local nnoremap = Remap.nnoremap
local xnoremap = Remap.xnoremap

nnoremap("<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
xnoremap("<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')
