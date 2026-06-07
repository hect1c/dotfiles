local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nmap = bind("n", {noremap = false})
local nnoremap = bind("n")
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")

local opts = { noremap = true, silent = true }

-- Normal --
-- Better window navigation
nnoremap("<C-h>", "<C-w>h", opts)
nnoremap("<C-j>", "<C-w>j", opts)
nnoremap("<C-k>", "<C-w>k", opts)
nnoremap("<C-l>", "<C-w>l", opts)

-- Resize with arrows
nnoremap("<C-Up>", ":resize -2<CR>", opts)
nnoremap("<C-Down>", ":resize +2<CR>", opts)
nnoremap("<C-Left>", ":vertical resize -2<CR>", opts)
nnoremap("<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
nnoremap("<S-l>", ":bnext<CR>", opts)
nnoremap("<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
nnoremap("<A-j>", "<Esc>:m .+1<CR>==gi", opts)
nnoremap("<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to exit insert mode
inoremap("jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
vnoremap("<", "<gv", opts)
vnoremap(">", ">gv", opts)

-- Move text up and down
vnoremap("p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
xnoremap("J", ":move '>+1<CR>gv-gv", opts)
xnoremap("K", ":move '<-2<CR>gv-gv", opts)
xnoremap("<A-j>", ":move '>+1<CR>gv-gv", opts)
xnoremap("<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Split Window
nnoremap("ss", ":split<Return><C-w>w", opts)
nnoremap("sv", ":vsplit<Return><C-w>w", opts)

-- New Tab
nnoremap("te", ":tabedit", opts)

-- Close buffers
nnoremap("<S-q>", "<cmd>lua Snacks.bufdelete()<CR>", opts)

-- Save
nnoremap("<leader>w", "<cmd>:w!<CR>", opts)

-- Close Quickfix-List
nnoremap("<leader>cc", "<cmd>:ccl<CR>", opts)
