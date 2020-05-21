# Configure oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time date)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_DATE_FORMAT=%D{%Y-%m-%d}

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Add kubectl autocompletions
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion zsh)
  alias k=kubectl
fi

# If on WSL, connect to Docker for Windows
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    export DOCKER_HOST=tcp://localhost:2375
fi

# Common aliases
alias please='sudo $(fc -ln -1)'

# Set default editor
export VISUAL=micro
export EDITOR="$VISUAL"

# Update PATH
export PATH="$HOME/.local/bin:$PATH"
