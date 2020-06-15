# Reset PATH
export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sr/games:/sbin:/bin"

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

# Add syntax-highlighting
if [ -x "$(command -v pygmentize)" ]; then
  function ccat { pygmentize -f terminal256 -P style=monokai -g $* }
  function cless { pygmentize -f terminal256 -P style=monokai -g $* | less -R }
fi

# Add kubectl autocompletions and helpers
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion zsh)
  alias k=kubectl
  function kw { watch -n1 -t -d kubectl $@ }
fi

# Add autocompletions for hashicorp tools
autoload -U +X bashcompinit && bashcompinit
for tool in vault terraform; do
  if [ -x "$(command -v $tool)" ]; then
    complete -o nospace -C /home/tvink/.local/bin/$tool $tool
  fi
done

# If on WSL, connect to Docker for Windows
if grep -iqE "(Microsoft|WSL)" /proc/version &> /dev/null; then
  export DOCKER_HOST=tcp://localhost:2375
  export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows"
fi

# Set up pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Use system certificates in python based tools
if [ -f /etc/ssl/certs/ca-certificates.crt ]; then
  export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
fi

# Common aliases
alias please='sudo $(fc -ln -1)'

# Set default editor
export VISUAL=micro
export EDITOR="$VISUAL"
