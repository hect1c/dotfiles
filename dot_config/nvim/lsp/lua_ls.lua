return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      hint = { enable = true },
      diagnostics = { disable = { "undefined-global" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      format = { enable = false }, -- stylua via conform
    },
  },
}
