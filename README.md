# Haku's Macbook Configs

## Sync configuration files

- Clone the repo into ~/\_config folder

- Create symlinks
  ```bash
  bash install.sh
  ```

## Installation

## System

## Apps
- Zed
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

### Terminal

- [oh-my-zsh](https://ohmyz.sh/)

  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

- [spaceship](https://github.com/spaceship-prompt/spaceship-prompt?tab=readme-ov-file#-installation)

  ```bash
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  ```

- [ghostty](https://ghostty.org/docs/install/binary#macos)

## Setup