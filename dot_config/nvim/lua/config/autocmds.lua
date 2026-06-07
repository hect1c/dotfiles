local augroup = vim.api.nvim_create_augroup
local UserCmds = augroup("UserCmds", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
  group = UserCmds,
  pattern = "*.rs",
  desc = "Enable inlay hints for Rust files",
  callback = function()
    vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
  end,
})

autocmd("BufWritePre", {
  group = UserCmds,
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
  group = UserCmds,
  desc = "Resize splits when window is resized",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  group = UserCmds,
  desc = "Disable line numbers in terminal",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Auto-create directories
autocmd("BufWritePre", {
  group = UserCmds,
  desc = "Create missing directories on save",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- When launched on a directory (e.g. `nvim .`), open the snacks explorer
-- sidebar instead of letting a full-window file listing take over.
autocmd("VimEnter", {
  group = UserCmds,
  desc = "Open explorer sidebar when nvim is launched on a directory",
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then
      return -- headless: nothing to show
    end
    if vim.fn.argc() ~= 1 then
      return
    end
    local target = vim.fn.argv(0)
    if vim.fn.isdirectory(target) ~= 1 then
      return
    end
    vim.cmd.cd(target)
    -- Replace the directory buffer with an empty one, then open the explorer.
    local dir_buf = vim.api.nvim_get_current_buf()
    vim.cmd.enew()
    pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
    vim.schedule(function()
      require("snacks").explorer()
    end)
  end,
})
