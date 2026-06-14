# Terminal

Shell, CLI tools, and runtimes for a new Mac environment. Ghostty is listed in [Applications](APPLICATIONS.md); its config lives in `configs/ghostty`.

## Shell & Plugins

- **[Oh My Zsh](https://ohmyz.sh/)** — Framework for managing Zsh configuration, with themes and plugins.

  ```bash
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** — Fish-like autosuggestions based on command history.

  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```

- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)** — Syntax highlighting for Zsh commands as you type.

  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

- **[Spaceship Prompt](https://github.com/spaceship-prompt/spaceship-prompt)** — Minimal, informative Zsh prompt with Git, Node, and directory context.

  ```bash
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  ```

## CLI Tools

- **[Claude Code](https://claude.com/product/claude-code)** — AI coding agent in the terminal. Build, debug, and ship from your codebase with Git and MCP integration.

  ```bash
  curl -fsSL https://claude.ai/install.sh | bash
  ```

- **[tlrc](https://github.com/tldr-pages/tldr)** — Concise, community-maintained command examples (tldr client).
  ```bash
  brew install tlrc
  ```

- **[duf](https://github.com/muesli/duf)** — Disk usage overview with a readable table layout.
  ```bash
  brew install duf
  ```

- **[gh](https://cli.github.com/)** — GitHub CLI for repos, issues, PRs, and auth from the terminal.
  ```bash
  brew install gh
  gh auth login
  ```

- **[lazygit](https://github.com/jesseduffield/lazygit)** — Terminal UI for Git — staging, commits, branches, and diffs.
  ```bash
  brew install lazygit
  ```

- **[lazydocker](https://github.com/jesseduffield/lazydocker)** — Terminal UI for Docker containers, images, and logs.
  ```bash
  brew install jesseduffield/lazydocker/lazydocker
  ```

- **[tree](http://mama.indstate.edu/users/ice/tree/)** — Classic directory tree listing.
  ```bash
  brew install tree
  ```

- **[tre](https://github.com/dduan/tre)** — Tree view for directories with `.gitignore` awareness.
  ```bash
  brew install tre
  ```

- **[fzf](https://github.com/junegunn/fzf)** — Fuzzy finder for files, history, and piping into other commands.
  ```bash
  brew install fzf
  ```

- **[bat](https://github.com/sharkdp/bat)** — `cat` with syntax highlighting and Git integration.
  ```bash
  brew install bat
  ```

## Node.js

- **[fnm](https://github.com/Schniz/fnm)** — Fast Node.js version manager.
  ```bash
  curl -fsSL https://fnm.vercel.app/install | bash
  brew upgrade fnm
  ```

- **[Bun](https://bun.com)** — All-in-one JavaScript runtime, bundler, and package manager.
  ```bash
  curl -fsSL https://bun.com/install | bash
  ```
