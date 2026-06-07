return {
  "folke/snacks.nvim",
  priority = 900,
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
██╗   ██╗███████╗██╗     ████████╗██████╗  █████╗ ██╗  ██╗
╚██╗ ██╔╝██╔════╝██║     ╚══██╔══╝██╔══██╗██╔══██╗██║  ██║
 ╚████╔╝ █████╗  ██║        ██║   ██████╔╝███████║███████║
  ╚██╔╝  ██╔══╝  ██║        ██║   ██╔══██╗██╔══██║██╔══██║
   ██║   ███████╗███████╗   ██║   ██║  ██║██║  ██║██║  ██║
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝]],
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      sources = {
        files  = { hidden = true, ignored = false },
        explorer = { hidden = true, git_status = true, follow_file = true, auto_close = true },
      },
    },
  },
  keys = {
    -- Find / pickers
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
    -- Explorer + git
    { "<leader>e",  function() Snacks.explorer() end, desc = "Explorer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- Terminal (replaces toggleterm)
    { "<C-\\>",     function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    -- Buffers
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  },
}
