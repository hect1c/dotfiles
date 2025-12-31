return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      'zbirenbaum/copilot.lua',
      'nvim-lua/plenary.nvim',
    },
    build = 'make tiktoken',
    opts = {
      debug = false,
      show_help = true,
      auto_follow_cursor = true,
      auto_insert_mode = true,
      clear_chat_on_new_prompt = false,
      context = 'buffers',
      history_path = vim.fn.stdpath('data') .. '/copilotchat_history',
      selection = function(source)
        local select = require('CopilotChat.select')
        return select.visual(source) or select.buffer(source)
      end,
      prompts = {
        Explain = {
          prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
        },
        Review = {
          prompt = '/COPILOT_REVIEW Review the selected code.',
          callback = function(response, source)
            local ns = vim.api.nvim_create_namespace('copilot_review')
            local diagnostics = {}
            for line in response:gmatch('[^\r\n]+') do
              if line:find('^line') then
                local start_line = tonumber(line:match('^line (%d+)'))
                table.insert(diagnostics, {
                  lnum = start_line - 1,
                  col = 0,
                  message = line,
                  severity = vim.diagnostic.severity.INFO,
                })
              end
            end
            vim.diagnostic.set(ns, source.bufnr, diagnostics)
          end,
        },
        Fix = {
          prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem.',
        },
        Optimize = {
          prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
        },
        Docs = {
          prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
        },
        Tests = {
          prompt = '/COPILOT_GENERATE Please generate tests for my code.',
        },
        FixDiagnostic = {
          prompt = 'Please assist with the following diagnostic issue in file:',
          selection = function(source)
            return require('CopilotChat.select').diagnostics(source)
          end,
        },
        Commit = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
          selection = function(source)
            return require('CopilotChat.select').gitdiff(source, true)
          end,
        },
      },
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)
      
      -- Create user commands after setup
      vim.api.nvim_create_user_command('CopilotChatVisual', function(args)
        local chat = require('CopilotChat')
        local select = require('CopilotChat.select')
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = '*', range = true })

      vim.api.nvim_create_user_command('CopilotChatBuffer', function(args)
        local chat = require('CopilotChat')
        local select = require('CopilotChat.select')
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = '*' })

      vim.api.nvim_create_user_command('CopilotChatInPlace', function(args)
        local chat = require('CopilotChat')
        local select = require('CopilotChat.select')
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = 'float',
            relative = 'cursor',
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = '*', range = true })
    end,
    keys = {
      { '<leader>ccb', '<cmd>CopilotChatBuffer<cr>', desc = 'CopilotChat - Chat with current buffer' },
      { '<leader>cce', '<cmd>CopilotChatExplain<cr>', desc = 'CopilotChat - Explain code' },
      { '<leader>cct', '<cmd>CopilotChatTests<cr>', desc = 'CopilotChat - Generate tests' },
      { '<leader>ccr', '<cmd>CopilotChatReview<cr>', desc = 'CopilotChat - Review code' },
      { '<leader>ccR', '<cmd>CopilotChatRefactor<cr>', desc = 'CopilotChat - Refactor code' },
      { '<leader>ccn', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat - Reset chat history' },
      { '<leader>ccs', '<cmd>CopilotChatSave<cr>', desc = 'CopilotChat - Save chat history' },
      { '<leader>ccl', '<cmd>CopilotChatLoad<cr>', desc = 'CopilotChat - Load chat history' },
      { '<leader>cco', '<cmd>CopilotChatOpen<cr>', desc = 'CopilotChat - Open chat window' },
      { '<leader>ccx', '<cmd>CopilotChatClose<cr>', desc = 'CopilotChat - Close chat window' },
      { '<leader>ccd', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'CopilotChat - Fix Diagnostic' },
      { '<leader>ccc', '<cmd>CopilotChatCommit<cr>', desc = 'CopilotChat - Generate commit message' },
      { '<leader>ccC', '<cmd>CopilotChatCommitStaged<cr>', desc = 'CopilotChat - Generate commit message for staged' },
      { '<leader>ccq', function()
        local input = vim.fn.input('Quick Chat: ')
        if input ~= '' then
          local chat = require('CopilotChat')
          local select = require('CopilotChat.select')
          chat.ask(input, { selection = select.buffer })
        end
      end, desc = 'CopilotChat - Quick chat' },
      -- Visual mode mappings
      { '<leader>cce', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'CopilotChat - Explain code' },
      { '<leader>cct', '<cmd>CopilotChatTests<cr>', mode = 'v', desc = 'CopilotChat - Generate tests' },
      { '<leader>ccr', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'CopilotChat - Review code' },
      { '<leader>ccR', '<cmd>CopilotChatRefactor<cr>', mode = 'v', desc = 'CopilotChat - Refactor code' },
      { '<leader>ccv', '<cmd>CopilotChatVisual<cr>', mode = 'v', desc = 'CopilotChat - Open in vertical split' },
      { '<leader>ccx', '<cmd>CopilotChatInPlace<cr>', mode = 'v', desc = 'CopilotChat - Run in-place code' },
    },
  },
}