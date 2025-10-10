# Reset PATH
export PATH="$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

# Configure oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.dotfiles/oh-my-zsh/custom"

ZSH_DISABLE_COMPFIX=true
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time date)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_DATE_FORMAT=%D{%Y-%m-%d}

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-uv-env
)

source $ZSH/oh-my-zsh.sh

# Add kubectl autocompletions and helpers
if [ -x "$(command -v kubectl)" ]; then
  source <(kubectl completion zsh)
  alias k=kubectl
  function kw { watch -n1 -t -d kubectl $@ }

  if [ -d "$HOME/.krew" ]; then
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
  fi
fi

# Add aliases for minikube
if [ -x "$(command -v minikube)" ]; then
  function mk { minikube kubectl -- $@ }
fi

# Add autocompletion and aliases for hashicorp tools
autoload -U +X bashcompinit && bashcompinit
if [ -x "$(command -v terraform)" ]; then
  alias tf=terraform
fi
for tool in vault terraform packer; do
  if [ -x "$(command -v $tool)" ]; then
    complete -o nospace -C "$(which $tool)" $tool
  fi
done

# Set up nvm
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Add autocompletion and aliases for the AWS CLI
if [ -x "$(command -v aws)" ]; then
  complete -C "$(which aws_completer)" aws
  function ec2 { aws ssm start-session --target $1 "${@:2}" }
fi

# Add autocompletion for NPM
if [ -x "$(command -v npm)" ]; then
  source <(npm completion)
fi

# If on WSL, add Windows utils to our PATH
if grep -iqE "(Microsoft|WSL)" /proc/version &> /dev/null; then
  export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows"
  export PATH="$PATH:/mnt/c/Windows/System32/WindowsPowerShell/v1.0"

  DOCKER_DIR="/mnt/c/Program Files/Docker/Docker/resources/bin"
  if [ -d $DOCKER_DIR ]; then
    export PATH="$PATH:$DOCKER_DIR"
  fi

  VSCODE_DIR="/mnt/c/Program Files/Microsoft VS Code/bin"
  if [ -d $VSCODE_DIR ]; then
    export PATH="$PATH:$VSCODE_DIR"
  fi
fi

# Set up dotnet tools PATH
if [ -x "$(command -v dotnet)" ]; then
  export PATH="$PATH:$HOME/.dotnet/tools"
fi

# Initialize homebrew
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Add syntax-highlighting
if [ -x "$(command -v pygmentize)" ]; then
  function ccat { pygmentize -f terminal256 -P style=monokai -g $* }
  function cless { pygmentize -f terminal256 -P style=monokai -g $* | less -R }
fi

# Set up pyenv
if [ -d "$HOME/.pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Set up uv
if [ -x "$(command -v uv)" ]; then
  eval "$(uv generate-shell-completion zsh)"
fi
if [ -x "$(command -v uvx)" ]; then
  eval "$(uvx --generate-shell-completion zsh)"
fi

# Set up poetry
if [ -x "$(command -v poetry)" ]; then
  function pyprojinit {
    POETRY_TMP_PATH=/tmp/poetry/$(basename "$PWD")
  	rm -rf "$POETRY_TMP_PATH"
  	mkdir -p "$POETRY_TMP_PATH"
  	pushd "$POETRY_TMP_PATH"
  	poetry new .
  	find . -not -name 'pyproject.toml' -delete
  	popd
  	mv "$POETRY_TMP_PATH/pyproject.toml" .
  	rm -rf "$POETRY_TMP_PATH"
  }

  function poetrynew {
    pyprojinit
    poetry add $@
    cd .
  }

  function pip2poetry {
  	if [ ! -f "requirements.txt" ]; then
  	  echo "No requirements.txt in the current directory!"
  	elif [ -f "pyproject.toml" ]; then
  	  echo "There is already a pyproject.toml in the current directory!"
  	else
      pyprojinit
      poetry add $(cat requirements.txt)
      cd .
  	fi
  }
fi

# Set up dagster
if [ -x "$(command -v dagster)" ]; then
  export DAGSTER_HOME="$HOME/.dagster"
fi

# Set up Go
GO_DIR="/usr/local/go/bin"
if [ -d $GO_DIR ]; then
  export PATH="$GO_DIR:$PATH"
fi

# Set up rust
if [ -d "$HOME/.cargo" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Use system certificates in python and node based tools
if [ -f /etc/ssl/certs/ca-certificates.crt ]; then
  export OPENSSL_CONF=/usr/lib/ssl/openssl.cnf
  export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
  export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
  export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
fi

# Common aliases
alias please='sudo $(fc -ln -1)'

# Set default editor
export VISUAL=micro
export EDITOR="$VISUAL"
