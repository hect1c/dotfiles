-- Inspired heavily by
--- https://github.com/rochakgupta/dotfiles

local settings = require('yeltrah.settings')

-- Set config before lazy
require("yeltrah.config")

-- Patch deprecated/changed LSP functions for Neovim 0.11+ (before lazy loads plugins)

-- 1. Patch jump_to_location -> show_document
if vim.lsp.util.show_document then
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.jump_to_location = function(location, offset_encoding, reuse_win)
    vim.lsp.util.show_document(location, offset_encoding, {
      focus = true,
      reuse_win = reuse_win,
    })
  end
end

-- 2. Patch make_position_params to auto-provide position_encoding
-- This fixes plugins (lspsaga, etc.) that call it without the required parameter
local original_make_position_params = vim.lsp.util.make_position_params
local original_make_range_params = vim.lsp.util.make_range_params
local original_make_given_range_params = vim.lsp.util.make_given_range_params

-- Helper to get offset encoding from active clients
local function get_position_encoding(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  -- Return encoding from first client, defaulting to utf-16
  if clients and #clients > 0 then
    return clients[1].offset_encoding or 'utf-16'
  end

  return 'utf-16'
end

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.make_position_params = function(window, position_encoding)
  -- If position_encoding not provided, auto-detect from active clients
  if not position_encoding then
    position_encoding = get_position_encoding()
  end
  return original_make_position_params(window, position_encoding)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.make_range_params = function(window, position_encoding)
  if not position_encoding then
    position_encoding = get_position_encoding()
  end
  return original_make_range_params(window, position_encoding)
end

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.make_given_range_params = function(start_pos, end_pos, bufnr, position_encoding)
  if not position_encoding then
    position_encoding = get_position_encoding(bufnr)
  end
  return original_make_given_range_params(start_pos, end_pos, bufnr, position_encoding)
end

-- Set package manager
require("yeltrah.lazy")

-- Set colorscheme after lazy
vim.cmd.colorscheme(settings.colorscheme)
