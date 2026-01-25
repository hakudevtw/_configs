# System ----------------------------------
# nvm
if command -v nvm >/dev/null 2>&1; then
  source "$(brew --prefix nvm)/nvm.sh"
fi

# fnm (fast node manager)
eval "$(fnm env --use-on-cd --shell zsh)"


# zed
export PATH=$HOME/.local/bin:$PATH

# Terminal  -------------------------------
# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# Theme config
ZSH_THEME="spaceship"

# Load Spaceship custom config (if it exists)
[ -f "$HOME/.config/spaceship.zsh" ] && source "$HOME/.config/spaceship.zsh"

# Carefully ordered plugins (syntax highlighting must be last)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Autosuggest settings
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# pnpm
export PNPM_HOME="/Users/$USER/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/$USER/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions