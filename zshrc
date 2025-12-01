# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Init zplug
source ~/.zplug/init.zsh

# Select zplug plugins
zplug "clvv/fasd"
zplug "junegunn/fzf"
zplug "yuhonas/zsh-aliases-lsd"
zplug "romkatv/powerlevel10k", as:theme, depth:1

# Make sure that plugins are installed
if ! zplug check --verbose; then
    printf "Installing missing zplug plugins...\n"
    zplug install
fi

# Load Zplug plugins
zplug load 2

# Define utility functions and aliases
backup_with_timestamp() {
    # Creates a timestamped backup of the given file or directory
    BACKUP_NAME="$1_backup_$(date +%Y-%m-%d_%H:%M:%S)"
    cp -r "$1" "$BACKUP_NAME"
    echo "Created backup at \"./$BACKUP_NAME\""
    unset BACKUP_NAME
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh






######### aliases
alias ls='gls -1FA --group-directories-first --time-style=long-iso'
alias l='ls'
alias ll='ls -l'
alias l.='ls -ld .?*'
alias la='ls -a'
alias lla='ls -al'
alias lal='ls -al'
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias g='git'
alias v='nvim'
alias hist='history'

alias env='env | grep -v _fzf | sort'
alias psg='ps -ef | grep '
alias watch='watch --color'

alias portForProcess='lsof -n -i | grep $1'
alias findbiggestfiles=' find . -type f -exec du -k  {} + | sort -nr | less'
alias findbiggestdirectories=' find . -type d -exec du -k  {} + | sort -nr | less'

alias PR='gh pr create --draft'
alias gg='git grep -i'

alias docker-stop-all-containers='docker stop $(docker ps -aq)'
alias docker-remove-all-containers='docker rm $(docker ps -aq)'
alias docker-remove-all-images='docker rmi $(docker images -q)'

alias PRqa+=' gh pr edit --add-label qa'
alias PRqa-=' gh pr edit --remove-label qa'
alias PRready=' gh pr ready'
alias PR2QA='gh pr create --draft && git checkout qa && git pull && git merge --squash @{-1} && git commit && git push && git checkout - && gh pr edit --add-label qa'

alias s='sbt'
alias sd='sbt -jvm-debug 5005'
alias cache='cd ~/Library/Caches/Coursier'

####### functions

epochSec() {
  echo "date +%s"
  date +%s
}
dateFromEpochSec() {
  echo "date -ur $1 '+%Y-%m-%d %H:%M:%S UTC'"
  date -ur $1 '+%Y-%m-%d %H:%M:%S UTC'
}
processOnPort() {
  echo "lsof -i $1"
  lsof -i :"$1"
  echo ""
}

jwt-decode() {
  jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' <<< $1
}

jwtiat () {
    if [ -z "$1" ]; then
        echo "usage: jwtiat <JWT>";
        return 1;
    fi;
        echo -n "iat: "
        echo "$1" | jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' | egrep '[0-9]{10}' | egrep "iat" |cut -f2 -d":" | cut -f1 -d"," | xargs -I bob date -ur bob '+%Y-%m-%d %H:%M:%S UTC'
}

jwtexp () {
    if [ -z "$1" ]; then
        echo "usage: jwtexp <JWT>";
        return 1;
    fi;
        echo -n  "exp: "
        echo "$1" | jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' | egrep '[0-9]{10}' | egrep "exp" |cut -f2 -d":" | cut -f1 -d"," | xargs -I bob date -ur bob '+%Y-%m-%d %H:%M:%S UTC'
}

jwtall () {
    if [ -z "$1" ]; then
        echo "usage: jwtall <JWT>";
        return 1;
    fi;
        echo -n "exp: "
        echo "$1" | jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' | egrep '[0-9]{10}' | egrep "exp" |cut -f2 -d":" | cut -f1 -d"," | xargs -I bob date -ur bob '+%Y-%m-%d %H:%M:%S UTC'
        echo -n "iat: "
        echo "$1" | jq -R 'split(".") | select(length > 0) | .[0],.[1] | @base64d | fromjson' | egrep '[0-9]{10}' | egrep "iat" |cut -f2 -d":" | cut -f1 -d"," | xargs -I bob date -ur bob '+%Y-%m-%d %H:%M:%S UTC'
}
##### Homebrew shell completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi
