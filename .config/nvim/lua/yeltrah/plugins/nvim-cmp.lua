return {
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    dependencies = {
      { 'saadparwaiz1/cmp_luasnip', lazy = true }, -- luasnip completion source for nvim-cmp
      {
        'rafamadriz/friendly-snippets',
        lazy = true,
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
  },
  {

    'dcampos/nvim-snippy',
    lazy = true,
  },
  {

    'honza/vim-snippets',
    lazy = true,
  },
  {
    -- Completion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- load cmp on InsertEnter
    dependencies = {
      -- Autocompletion plugin
      -- Completion Sources --
      { 'hrsh7th/cmp-nvim-lsp', lazy = true }, -- nvim-cmp source for neovim builtin LSP client
      { 'hrsh7th/cmp-path', lazy = true }, -- nvim-cmp source for path
      { 'hrsh7th/cmp-buffer', lazy = true }, -- nvim-cmp source for buffer words
      { 'hrsh7th/cmp-nvim-lua', lazy = true }, -- nvim-cmp source for nvim lua
      { 'hrsh7th/cmp-emoji', lazy = true }, -- nvim-cmp source for emoji
      { 'hrsh7th/cmp-cmdline', lazy = true }, --nvim-cmp source for vim's cmdline.
      { 'hrsh7th/cmp-calc', lazy = true }, --nvim-cmp source for vim's cmdline.
      { 'hrsh7th/cmp-calc', lazy = true }, --nvim-cmp source for vim's cmdline.
      { 'onsails/lspkind.nvim', lazy = true },
    },
    config = function()
      local cmp = require('cmp')
      local snippy = require('snippy')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind')
      local icons = {
        Text = '',
        Method = 'm',
        Function = '',
        Constructor = '',
        Field = '',
        Variable = '',
        Class = '',
        Interface = '',
        Module = '',
        Property = '',
        Unit = '',
        Value = '',
        Enum = '',
        Keyword = '',
        Snippet = '',
        Color = '',
        File = '',
        Reference = '',
        Folder = '',
        EnumMember = '',
        Constant = '',
        Struct = '',
        Event = '',
        Operator = '',
        TypeParameter = '',
      }

      local check_backspace = function()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
      end

      cmp.setup({
        enabled = function()
          -- Disable in buffers corresponding to telescope prompt
          return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt'
        end,
        window = {
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
        formatting = {
          expandable_indicator = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = lspkind.cmp_format({
            with_text = false,
            maxwidth = 50,
            mode = 'symbol_text',
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              -- Kind icons
              -- This concatonates the icons with the name of the item kind
              vim_item.kind = string.format('%s', icons[vim_item.kind], vim_item.kind)
              -- Source
              vim_item.menu = ({
                buffer = '[Buffer]',
                nvim_lsp = '[LSP]',
                luasnip = '[LuaSnip]',
                nvim_lua = '[Lua]',
                path = '[Path]',
                emoji = '[Emoji]',
                neorg = '[Neorg]',
                spell = '[Spell]',
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        snippet = {
          expand = function(args)
            snippy.expand_snippet(args.body)
          end,
        },
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
          ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif snippy.can_expand_or_advance() then
              snippy.expand_or_advance()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
              snippy.previous()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            'i',
            's',
          }),
        }),
        sources = {
          { name = 'snippy' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'emoji' },
          { name = 'neorg' },
          { name = 'luasnip' },
          { name = 'treesitter' },
        },
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' },
            },
          },
        }),
      })
    end,
  },
}
