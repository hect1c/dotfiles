local opts = { noremap = true, silent = true }
local Remap = require("yeltrah.config.keymaps.bindings")
local nnoremap = Remap.nnoremap

nnoremap("<leader>ti", ":!terraform init<CR>", opts)
nnoremap("<leader>tv", ":!terraform validate<CR>", opts)
nnoremap("<leader>tp", ":!terraform plan<CR>", opts)
nnoremap("<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
