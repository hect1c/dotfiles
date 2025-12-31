return function(on_attach)
  return {
    on_attach = on_attach,
    -- Inherit global capabilities (includes offsetEncoding and cmp capabilities)
    settings = {
      -- IMPORTANT: basedpyright does NOT support python.* settings
      -- Only basedpyright.* settings are supported
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
    -- Explicitly disable python.* settings to prevent conflicts
    before_init = function(initialize_params, config)
      -- Remove any python.* settings that might be added by lspconfig defaults
      if config.settings and config.settings.python then
        config.settings.python = nil
      end
    end,
    -- Specify filetypes explicitly to ensure proper detection
    filetypes = { 'python' },
    -- Use root_markers for Neovim 0.11+ (replaces root_dir function)
    -- IMPORTANT: pyrightconfig.json and .git first for monorepo support
    -- This ensures basedpyright finds the monorepo root, not sub-package pyproject.toml files
    root_markers = { 'pyrightconfig.json', '.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
  }
end