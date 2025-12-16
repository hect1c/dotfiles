return {
  "coder/claudecode.nvim",
  dependencies = {
    "folke/snacks.nvim", -- Required dependency per plugin docs
  },
  config = function()
    require("claudecode").setup({
      terminal = {
        provider = "none", -- Headless mode: Claude runs in tmux pane, not Neovim
      },
    })
  end,
  keys = {
    -- Only context-sending commands work with provider="none"
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send Selection to Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add Buffer to Claude" },
  },
}
