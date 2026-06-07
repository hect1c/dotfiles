return {
  settings = {
    -- no experimental.useFlatConfig: let the server auto-detect flat config
    format = false,
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(_, bufnr)
    -- lint-fix on save (NOT formatting; prettier handles formatting)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "silent! EslintFixAll",
    })
  end,
}
