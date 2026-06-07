return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        indexing = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "none",
          reportUnusedVariable = "none",
          reportMissingImports = "warning",
          reportUndefinedVariable = "error",
          reportGeneralTypeIssues = "error",
          reportAttributeAccessIssue = "error",
          reportCallIssue = "error",
          reportArgumentType = "error",
          reportAssignmentType = "error",
          reportMissingParameterType = "none",
          reportUnknownParameterType = "none",
          reportUnknownArgumentType = "none",
          reportUnknownVariableType = "none",
          reportUnknownMemberType = "none",
          reportMissingTypeArgument = "none",
          reportPrivateUsage = "none",
          reportConstantRedefinition = "none",
          reportIncompatibleMethodType = "none",
          reportUnusedClass = "none",
          reportUnusedFunction = "none",
        },
      },
    },
  },
  before_init = function(_, config)
    if config.settings and config.settings.python then
      config.settings.python = nil
    end
  end,
  filetypes = { "python" },
  root_markers = { "pyrightconfig.json", ".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
}
