-- Claude Code keymaps (coder/claudecode.nvim with headless tmux mode)
-- Note: With provider="none", only context-sending commands work
-- Terminal management is handled by tmux (Ctrl+Space a/A)

local opts = { noremap = true, silent = true }
local Remap = require("yeltrah.config.keymaps.bindings")
local vnoremap = Remap.vnoremap
local nnoremap = Remap.nnoremap

-- Send selection to Claude (works with headless mode)
vnoremap("<leader>as", "<cmd>ClaudeCodeSend<CR>", opts)       -- [A]I [S]end selection

-- Add current buffer to Claude context
nnoremap("<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", opts)      -- [A]I add [B]uffer
