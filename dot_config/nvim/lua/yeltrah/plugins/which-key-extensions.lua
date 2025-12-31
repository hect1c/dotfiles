return {
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      
      -- Add modern key group descriptions
      vim.list_extend(opts.spec, {
        { '<leader>c', group = 'Copilot' },
        { '<leader>cc', group = 'Copilot Chat' },
        { '<leader>f', desc = 'Format' },
        { '<leader>g', group = 'Git' },
        { '<leader>p', group = 'Project/Search' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>x', group = 'Diagnostics/Quickfix' },
        { '<leader>s', group = 'Search/Replace' },
        { '<leader>t', group = 'Toggle/Terminal' },
        { 'g', group = 'Goto' },
        { 'gp', group = 'Preview' },
        { ']', group = 'Next' },
        { '[', group = 'Previous' },
      })
      
      return opts
    end,
  },
}