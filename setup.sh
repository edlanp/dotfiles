#!/bin/bash

softwareupdate --install --all
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install
brew git
brew wget 
brew curl
brew ripgrep
brew fzf
brew fd

