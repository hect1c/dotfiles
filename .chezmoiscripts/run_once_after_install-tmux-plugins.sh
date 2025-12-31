#!/bin/bash

echo "Installing tmux plugins..."

# Install TPM plugins
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  ~/.tmux/plugins/tpm/bin/install_plugins
  echo "Tmux plugins installed!"
  echo "Tip: Press prefix + I in tmux to install/update plugins"
else
  echo "TPM not found. Install it first, then run: ~/.tmux/plugins/tpm/bin/install_plugins"
fi
