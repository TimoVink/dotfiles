# dotfiles

These are my personal `dotfiles`, with installation powered by [dotbot](https://github.com/anishathalye/dotbot).

Running the installation script will attempt to:
 * Install `brew` if on `macOS`
 * Install `zsh`
 * Install `oh-my-zsh`, along with the following extensions:
   * The `powerlevl10k` theme
   * The `zsh-autosuggestions` plugin
   * The `zsh-syntax-highlighting` plugin
 * Copy the `.bashrc`, `.zshrc`, and `.gitconfig` into place

The `.zshrc` will configure the theme and plugins mentioned above. Additionally for each of the following tools (if they were installed seperately) it will make sure they are on the `PATH`, initialized, and have shell autocompletions configured as appropriate:
 * `aws`
 * `npm`
 * `pyenv`
 * `terraform`
 * `packer`
 * `vault`
 * `kubectl`

Finally we set up some convenient aliases and functions, such as:
 * `please` to re-run the previous command with `sudo`
 * `ccat` and `cless` ("`c`" for "_coloured_") for invoking `cat` and `less` with syntax highlighting
 * `ec2` for starting an SSH session via AWS Session Manager


## Setup Instructions

```zsh
git clone https://github.com/TimoVink/dotfiles ~/.dotfiles --recurse-submodules
cd ~/.dotfiles
./install
```
