# .bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH=$PATH:/usr/local/go/bin
export PATH=/home/ernesti/.opencode/bin:$PATH
export TMPDIR=~/.gotmp
export GOTMPDIR=~/.gotmp

alias up="sudo dnf up -y && flatpak update -y && brew upgrade"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
