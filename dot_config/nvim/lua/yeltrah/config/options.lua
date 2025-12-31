vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

-- insert 2 spaces for tab
vim.opt.tabstop = 2

-- number of spaces that <Tab> uses while editing
vim.opt.softtabstop = 2

-- the number of spaces inserted for each indentation
vim.opt.shiftwidth = 2

-- convert tabs to spaces
vim.opt.expandtab = true

vim.opt.smartindent = true

-- display lines as one long line
vim.opt.wrap = false

-- Do not create swap files
vim.opt.swapfile = false

-- Better block editing in visual mode
vim.opt.virtualedit = 'block'

-- creates a backup file
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Automatically save undo history to an undo file when writing a buffer to a file
vim.opt.undofile = true

-- Enable 24-bit RGB colors
vim.opt.termguicolors = true

-- Better completion experience
vim.opt.completeopt = 'menu,menuone,noselect'

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = 'longest:full,full'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- Highlight search result
vim.opt.hlsearch = false

-- NOTE: You should make sure your terminal supports this
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Performance optimizations
vim.opt.lazyredraw = true
vim.opt.regexpengine = 1
vim.opt.synmaxcol = 240

-- Modern editor features
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Open horizontal split below
vim.opt.splitbelow = true

-- Open vertical split right
vim.opt.splitright = true

vim.opt.cursorline = true

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- disable netrw at the very start of your init.lua (strongly advised)
-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Note: Removed global winborder to avoid conflicts with plugin-specific borders
