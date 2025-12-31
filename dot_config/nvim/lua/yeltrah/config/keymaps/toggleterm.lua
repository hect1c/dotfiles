local opts = { noremap = true, silent = true }

-- ToggleTerm keymaps
vim.keymap.set('n', '<C-t>', '<cmd>ToggleTerm direction=float<cr>', opts)
vim.keymap.set('t', '<C-t>', '<cmd>ToggleTerm<cr>', opts) -- Close from terminal mode