-- Git
local opts = { noremap = true, silent = true }
local Remap = require("yeltrah.config.keymaps.bindings")
local nnoremap = Remap.nnoremap

nnoremap("<leader>gg", "<cmd>:LazyGitCurrentFile<CR>", opts)
