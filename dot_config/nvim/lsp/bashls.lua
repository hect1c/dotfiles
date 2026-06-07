return {
  cmd = { "bash-language-server", "start" },
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh)" },
  filetypes = { "sh", "zsh" },
  root_markers = { ".git" },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
    },
  },
}
