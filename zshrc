export ZSH="$HOME/.oh-my-zsh"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator time date)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_DATE_FORMAT=%D{%Y-%m-%d}

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Add kubectl autocompletions
if ! [ -x "$(command -v git)" ]; then
  source <(kubectl completion zsh)
fi

# If on WSL, connect to Docker for Windows
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    export DOCKER_HOST=tcp://localhost:2375
    cd $HOME
fi
