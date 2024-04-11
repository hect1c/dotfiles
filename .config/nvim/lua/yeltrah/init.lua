-- Inspired heavily by
--- https://github.com/rochakgupta/dotfiles

local settings = require('yeltrah.settings')

-- Set config before lazy
require("yeltrah.config")

-- Set package manager
require("yeltrah.lazy")

-- Set colorscheme after lazy
vim.cmd.colorscheme(settings.colorscheme)
