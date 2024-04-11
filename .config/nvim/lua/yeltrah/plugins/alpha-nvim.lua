return {
	{
    -- Greeter
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        [[ __   __ ___  _  _____  ___   __   _  _  ]],
        [[ \ `v' /| __|| ||_   _|| _ \ /  \ | || | ]],
        [[  `. .' | _| | |_ | |  | v /| /\ || >< | ]],
        [[   !_!  |___||___||_|  |_|_\|_||_||_||_| ]],
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
        dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
        dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }
      alpha.setup(dashboard.config)
    end,
	},
}
