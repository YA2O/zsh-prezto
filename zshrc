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
zplug load

# Define utility functions and aliases
backup_with_timestamp() {
    # Creates a timestamped backup of the given file or directory
    BACKUP_NAME="$1_backup_$(date +%Y-%m-%d_%H:%M:%S)"
    cp -r "$1" "$BACKUP_NAME"
    echo "Created backup at \"./$BACKUP_NAME\""
    unset BACKUP_NAME
}
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias bat="batcat"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
