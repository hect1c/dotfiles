local augroup = vim.api.nvim_create_augroup
YeltrahGroup = augroup("Yeltrah", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
  group = YeltrahGroup,
  pattern = "*.rs",
  desc = "Enable inlay hints for Rust files",
  callback = function()
    vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
  end,
})

autocmd("BufWritePre", {
  group = YeltrahGroup,
  pattern = "*",
  desc = "Remove trailing whitespace on save",
  command = "%s/\\s\\+$//e",
})

-- File-type specific settings
local filetype_group = augroup("FileTypeSettings", {})

autocmd("FileType", {
  group = filetype_group,
  pattern = { "gitcommit", "markdown", "text" },
  desc = "Enable wrap and spell for text files",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("FileType", {
  group = filetype_group,
  pattern = { "json", "jsonc" },
  desc = "Set JSON formatting options",
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Window management
autocmd("VimResized", {
  group = YeltrahGroup,
  desc = "Resize splits when window is resized",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  group = YeltrahGroup,
  desc = "Disable line numbers in terminal",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Auto-create directories
autocmd("BufWritePre", {
  group = YeltrahGroup,
  desc = "Create missing directories on save",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
