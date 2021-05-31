# setup PATH
PATH="$HOME/dotfiles/bin:$PATH"

# environment vars
export EDITOR='nvim'

# git aliases
alias g="git"
alias gb="git branch"
alias gl="git pull"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"

# misc aliases
alias l="ls -lah"
alias v="nvim"
alias ..="cd .."
alias binst="bundle install"
alias be="bundle exec"
alias brk="bundle exec rake"

# tmux by default
if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then
    tmux -u -CC attach-session || tmux -u -CC new-session
    exit
fi
