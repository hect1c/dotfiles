-- Enable the new lua-loader that byte-compiles and caches lua files.
vim.loader.enable()

-- Leader must be set before lazy / plugins load.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
