#!/bin/bash

# --- 🛠️ Helper Functions ---

# Function to print a stage start header that's easy to read
print_start() {
    # Using tput to add colors and bold text for visual separation
    echo ""
    echo "$(tput setaf 6)$(tput bold)✨ STARTING: $1 ✨$(tput sgr0)"
    echo "$(tput setaf 6)--------------------------------------------------$(tput sgr0)"
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

# --- ⚙️ Main Setup Script: Let's Get Everything Ready ---

# 1. Symlink Creation
print_start "Setting Up Symlinks"

ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"
echo "  ➡️ Symlinked my Git configuration: ~/.gitconfig"

ln -sf "$PWD/.zprofile" "$HOME/.zprofile"
echo "  ➡️ Symlinked my Zsh login profile: ~/.zprofile"

ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
echo "  ➡️ Symlinked my Zsh configuration: ~/.zshrc"

# IMPORTANT: I need to source my .zprofile right now to set the PATH for Homebrew,
# so the rest of the script can find the 'brew' command after installation.
if [ -f "$PWD/.zprofile" ]; then
    echo "  ⚙️ Sourcing the custom .zprofile now to update my script's PATH."
    source "$PWD/.zprofile"
    echo "  ✅ PATH updated for this script's session."
else
    # This warning means the file is missing from the dotfiles directory.
    echo "$(tput setaf 1)  ⚠️ CRITICAL WARNING: My source file ($PWD/.zprofile) is missing. Homebrew install might fail.$(tput sgr0)"
fi

print_end "Setting Up Symlinks"

# 2. System Prerequisites (Updates & Xcode)
print_start "Checking for System Prerequisites"

# I always want to be asked about system updates, they can take forever.
if confirm "Do I want to run 'softwareupdate --install --all' now?"; then
    echo "  ⚙️ Starting system software update..."
    sudo softwareupdate --install --all
    echo "  ✅ Software update complete!"
else
    echo "  ➡️ I skipped system update"
fi

# I need Xcode Command Line Tools for Homebrew to compile stuff. I'll check if it's there first.
if xcode-select -p &> /dev/null; then
    echo "  🛠️ Xcode Command Line Tools are already installed. Great!"
elif confirm "Do I want to install the Xcode Command Line Tools? (I need this for development)"; then
    echo "  ⚙️ Starting Xcode Command Line Tools installation..."
    xcode-select --install
    echo "  ✅ Installation started. I need to follow the GUI prompt!"
else
    echo "  ➡️ I skipped Xcode tools. I need to install this before running 'brew install'!"
fi

print_end "Checking for System Prerequisites"

# 3. Homebrew Installation and Package Setup 
print_start "Installing Homebrew"

# This path is for m4 mac, I think its different elsewere?
HOMEBREW_PATH="/opt/homebrew/bin/brew"

if ! command -v brew &> /dev/null && ! [ -x "$HOMEBREW_PATH" ]; then
    echo "  🍺 Homebrew not found. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "  ✅ Homebrew installed!"
else
    echo "  🍺 Homebrew is already installed. I'll update my packages now."
    brew update
fi

# I'm installing my core set of command-line tools in one go.
echo "  📦 Installing my core Homebrew packages: git, ripgrep, fzf, fd..."
brew install git ripgrep fzf fd
echo "  🎉 All essential packages installed successfully!"
# Note fzf has a post install step, skipping these as I source the fzf scripts in .zshrc


print_end "Installing Homebrew"
echo "$(tput setaf 5)$(tput bold)🚀 Setup Complete GLHF💻$(tput sgr0)"
