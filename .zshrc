# History Settings
HISTFILE="$HOME/.zsh_history" # My history file location
HISTSIZE=10000               # I want 10,000 commands in my shell memory.
SAVEHIST=10000               # I want to save 10,000 commands to the history file.
setopt APPEND_HISTORY        # I want to append new commands to the file, not overwrite it.
setopt HIST_IGNORE_DUPS      # I don't want duplicate commands saved right next to each other.
setopt HIST_IGNORE_SPACE     # Commands starting with a space ' ' are ignored (good for quick, forgotten secrets).

# Ripgrep Alias 
alias rg='rg --smart-case' # I want ripgrep to be smart: case-insensitive unless I use an uppercase letter.

# ==============================================================================
# INTEGRATION
# ==============================================================================

# Initialize Zsh Completion: This is mandatory for Zsh's powerful tab-completion.
autoload -Uz compinit
compinit
zstyle ':fzf-completion:*' fzf-bin /opt/homebrew/bin/fzf
if [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]; then
    source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
    source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Created by `pipx` on 2025-10-14 00:27:52
export PATH="$PATH:/Users/edlanp/.local/bin"
