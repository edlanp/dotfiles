# This is my personal .zprofile file.

# --- 🛠️  Helper Functions ---
# used whenever I export PATH
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;; # already in PATH
    *) export PATH="$1:$PATH" ;;
  esac
}

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python
PYTHON_VERSION="3.12.7"
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi
if ! command -v pipx &> /dev/null; then
  pipx ensurepath
fi

# TODO: java
# export JAVA_HOME="/usr/local/opt/openjdk/..."

# Created by `pipx` on 2025-10-14 00:27:52
export PATH="$PATH:/Users/edlanp/.local/bin"
