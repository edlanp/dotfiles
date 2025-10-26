#!/bin/bash

# Get the directory where the script is located (not where it's executed from)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if the current working directory ($PWD) is the same as the script directory
if [ "$PWD" != "$SCRIPT_DIR" ]; then
    echo "$(tput setaf 1)$(tput bold)🛑 ERROR: Script must be run from its own directory!$(tput sgr0)"
    echo "       Current Directory: $PWD"
    echo "       Expected Directory: $SCRIPT_DIR"
    exit 1
fi

if [[ ! -f "$HOME/.zprofile" || ! -f "$HOME/.zshrc" ]]; then
    exit 1
fi

# --- 🛠️ Helper Functions ---

# Function to print a stage start header that's easy to read
print_start() {
    echo "$(tput setaf 6)--------------------------------------------------$(tput sgr0)"
    echo "$(tput setaf 6)$(tput bold)✨ STARTING: $1 $(tput sgr0)"
}

# Function to print a stage end footer
print_end() {
    echo "$(tput setaf 2)✅ FINISHED: $1$(tput sgr0)"
    echo "$(tput setaf 2)--------------------------------------------------$(tput sgr0)"
}

# Function to get user confirmation (y/n)
confirm() {
    # I want the user prompt to be clear and pause the script
    read -r -p "$(tput setaf 3)❓ $1 (y/n): $(tput sgr0)" response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# --- ⚙️  Main Setup Script---

print_start "Symlinks"
# 1. Symlink Creation
ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"
echo "  Symlinked my Git configuration: ~/.gitconfig"

ln -sf "$PWD/.zprofile" "$HOME/.zprofile"
echo "  Symlinked my Zsh login profile: ~/.zprofile"

ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
echo "  Symlinked my Zsh configuration: ~/.zshrc"

print_end "Symlinks"

# 2. System Prerequisites (Updates & Xcode)
print_start "Prerequisites"

# I always want to be asked about system updates, they can take forever.
if confirm "Do I want to run 'softwareupdate --install --all' now?"; then
    echo "  Starting system software update..."
    sudo softwareupdate --install --all
    echo "  Software update complete!"
else
    echo "  I skipped system update"
fi

# I need Xcode Command Line Tools for Homebrew to compile stuff. I'll check if it's there first.
if xcode-select -p &> /dev/null; then
    echo "  Xcode Command Line Tools already installed."
elif confirm "Do I want to install the Xcode Command Line Tools? (I need this for development)"; then
    echo "  Starting Xcode Command Line Tools installation..."
    xcode-select --install
    echo "  Installation started. I need to follow the GUI prompt!"
else
    echo "  I skipped Xcode tools. I need to install this before running 'brew install'!"
fi

print_end "System Prerequisites"

# 3. Homebrew Installation and Package Setup 
print_start "Homebrew 🍺"

# This path is for m4 mac, I think its different elsewere?
HOMEBREW_PATH="/opt/homebrew/bin/brew"

if ! command -v brew &> /dev/null && ! [ -x "$HOMEBREW_PATH" ]; then
    echo "  Homebrew not found. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "  Homebrew installed!"
else
    echo "  Homebrew is already installed. I'll update my packages now."
    brew update
fi

# I'm installing my core set of command-line tools in one go.
echo "  Installing my core Homebrew packages: git, ripgrep, fzf, fd..."
brew install git ripgrep fzf fd
echo "  All essential packages installed successfully!"
# Note fzf has a post install step, skipping these as I source the fzf scripts in .zshrc

# Install Applications (Casks)
echo "  Installing my core Homebrew Cask applications: iTerm2..."
# Use '--cask' for GUI applications like iTerm2
brew install --cask iterm2
echo "  iTerm2 installed successfully!"

# 4. Python
print_start "Python 🐍"
# Check and install pyenv if missing
if ! command -v pyenv &> /dev/null; then
    brew install pyenv
    source ./zprofile # All path mods in zprofile (and I need pyenv init in the next step)
else
    echo "  pyenv already installed."
fi
if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
    echo "  Installing Python ${PYTHON_VERSION}..."
    pyenv install ${PYTHON_VERSION}
    pyenv global ${PYTHON_VERSION}
else
    echo "  Python ${PYTHON_VERSION} already installed."
fi

# Install pipx for isolated CLI tools
if ! command -v pipx &> /dev/null; then
    brew install pipx
    pipx ensurepath
    pipx install black
    pipx install flake8
    pipx install mypy
    pipx install ipython
else
    echo "  pipx already installed."
fi


print_end "Python "

print_start "Node ⬡"
if ! command -v nvm &> /dev/null; then
   echo "  Installing nvm..."
   brew install nvm
fi

source ./zshrc

if ! nvm list | grep -q "${NODE_VERSION}"; then
    nvm install ${NODE_VERSION}
    nvm alias default ${NODE_VERSION}
else
    nvm use default 
fi
   
print_start "Node ⬡"

print_start "NeoVim 🇳"
   brew install neovim
print_end "NeoVim 🇳"

# Everything after here is just diagnostics
echo "$(tput setaf 5)$(tput bold)🚀 Setup Complete GLHF💻$(tput sgr0)"
echo ""
echo "   PATH Entries (Sorted):"
echo ""

# List and sort the PATH entries, adding simple indentation to each line
echo "$PATH" | tr ':' '\n' | sort | sed 's/^/      /'

echo ""

echo "   🐍 Using Python: $(python3 --version)"
