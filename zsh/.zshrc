if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

ZSH_THEME="powerlevel10k/powerlevel10k"

export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(git aliases battery brew colorize cp dnf emoji fasd
gh git git-auto-fetch gitfast lol npm nvm pip python qrcode
rclone safe-paste ssh systemd tailscale thefuck vscode z
zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export PATH="/home/ernesti/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export EDITOR='nano'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

alias up="sudo dnf up -y && flatpak update -y && brew upgrade"
