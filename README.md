# Haku's MacBook Configuration

- [ ] Create interactive setup script

## Apps Installation

### Editors

- [Zed](https://zed.dev/)
  ```bash
  curl -f https://zed.dev/install.sh | sh
  ```

- Cursor
  ```bash
  brew install --cask cursor
  ```
- VScode
  ```bash
  brew install --cask cursor
  ```
- Notion

- Cursor
- VScode
- Notion
- Line
- Scroll Reverser
- Raycast
- Karabiner-EventsViewer
- Karabiner-Elements
- Chrome
- Arc

## Terminal Setup

### Terminal Emulator

- [ghostty](https://ghostty.org/docs/install/binary#macos)
  ```bash
  brew install --cask ghostty
  ```

### Theme and Plugins

- [oh-my-zsh](https://ohmyz.sh/) - Oh My Zsh for Terminal, provides a modern prompt for terminal.

  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) - Autosuggestions for Terminal, provides autosuggestions for terminal. 

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md) - Syntax Highlighting for Terminal, provides syntax highlighting for terminal.

  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

- [spaceship](https://github.com/spaceship-prompt/spaceship-prompt?tab=readme-ov-file#-installation) - Spaceship Prompt for Terminal, provides a modern prompt for terminal.

  ```bash
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  ```

### Terminal Tools

- [tlrc](https://github.com/tldr-pages/tldr/tree/main) - TLDR Client for Terminal, provides concise documentation for commands.
  ```bash
  brew install tlrc
  ```

- [duf](https://github.com/muesli/duf) - Disk Usage/Free Utility for Terminal, provides a visual representation of disk usage.
  ```bash
  brew install duf
  ```

- [gh](https://cli.github.com/) - GitHub CLI, provides a command-line interface for GitHub.
  ```bash
  brew install gh
  gh auth login
  ```

- [lazygit](https://github.com/jesseduffield/lazygit) - Simple Terminal UI for Git, provides a simple terminal UI for Git.
  ```bash
  brew install lazygit
  ```

- [lazydocker](https://github.com/jesseduffield/lazydocker) - Simple Terminal UI for Docker, provides a simple terminal UI for Docker.
  ```bash
  brew install jesseduffield/lazydocker/lazydocker
  ```

- [tre](https://github.com/dduan/tre) - Tree Command for Terminal, provides a tree command for terminal.
  ```bash
  brew install tre
  ```

- [fzf](https://github.com/junegunn/fzf) - Fuzzy Finder for Terminal, provides a fuzzy finder for terminal.
  ```bash
  brew install fzf
  ```

### Node.js

- [fnm](https://github.com/Schniz/fnm) - Fast Node Manager for Node.js, provides a fast Node.js manager for terminal.
  ```bash
  # Install fnm
  curl -fsSL https://fnm.vercel.app/install | bash

  # Upgrade fnm
  brew upgrade fnm
  ```

## Setup configuration files

1.  Clone the repo into ~/\_configs folder
2.  Hop into the repo and run the install script

    ```bash
    cd ~/_configs
    bash install.sh
    ```
3.  Done!

## Setup
