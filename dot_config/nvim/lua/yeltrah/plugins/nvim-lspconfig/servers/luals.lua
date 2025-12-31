return function(on_attach)
  return {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- Disable lua_ls formatting in favor of stylua via null-ls
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Disable undefined global vim warnings - handled by lazydev
          disable = { 'undefined-global' },
        },
        workspace = {
          checkThirdParty = false,
        },
        -- do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    },
  }
end
