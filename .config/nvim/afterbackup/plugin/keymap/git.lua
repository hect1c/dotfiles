-- Git
local opts = { noremap = true, silent = true }
local Remap = require("yeltrah.keymaps")
local nnoremap = Remap.nnoremap

nnoremap("<leader>gg", "<cmd>:LazyGitCurrentFile<CR>", opts)
