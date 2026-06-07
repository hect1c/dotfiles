return {
  filetypes = {
    "javascript", "javascriptreact", "javascript.jsx",
    "typescript", "typescriptreact", "typescript.tsx",
  },
  settings = {
    typescript = { inlayHints = {
      parameterNames = { enabled = "literals" },
      variableTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = true },
    } },
    javascript = { inlayHints = {
      parameterNames = { enabled = "literals" },
      variableTypes = { enabled = true },
    } },
  },
}
