# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions virtualenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# eval "$(dircolors $HOME./.dir_colors/dircolors)"
# eval `dircolors /home/tomand/.dir_colors/dircolors`
#

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

alias ls='eza -la --icons=always'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

display_csv() {
    column -s, -t < "$1" | less -S
}

# alias nvchad="NVIM_APPNAME=NvChad nvim"

function nvims() {
  items=("default")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.cargo/bin:$PATH"

# # Settings for interactive shells with a TTY attached
# if [[ -t 0 ]]; then
#   # Disable Ctrl+S/Ctrl+Q flow control only if stdin is a terminal
#   stty -ixon
#   # Remove bindings only if stdin is a terminal (optional but safe)
#   bindkey -r "^S"
#   bindkey -r "^R" # Keep this only if you intentionally want Ctrl+R disabled
# fi


bindkey -r "^S"
# bindkey -r "^R"

# set vi-mode
set -o vi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tomand/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tomand/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tomand/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tomand/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# --- Claude Code: three subscriptions on one machine ---
# The personal seat must run with CLAUDE_CONFIG_DIR unset: the Keychain entry is
# named "Claude Code-credentials-<sha256(config_dir)[0:8]>" and the hash suffix is
# added whenever the variable is set, so pointing it at the default ~/.claude
# still produces a different entry and looks like a logout.
CLAUDE_DIR_FINI="$HOME/.claude-finitec"
CLAUDE_DIR_LPP="$HOME/.claude-lpp"

claude() {
  if [[ -n "$CLAUDE_CONFIG_DIR" ]]; then
    command claude "$@"
    return
  fi
  case "$PWD/" in
    "$HOME"/work/finitec/*) CLAUDE_CONFIG_DIR="$CLAUDE_DIR_FINI" command claude "$@" ;;
    "$HOME"/work/kempuri/*) CLAUDE_CONFIG_DIR="$CLAUDE_DIR_LPP" command claude "$@" ;;
    *)                      command claude "$@" ;;
  esac
}

cmax() { env -u CLAUDE_CONFIG_DIR claude "$@" }

cfini() { CLAUDE_CONFIG_DIR="$CLAUDE_DIR_FINI" command claude "$@" }

clpp() { CLAUDE_CONFIG_DIR="$CLAUDE_DIR_LPP" command claude "$@" }

claude-who() {
  local fmt='if .loggedIn then "\(.email) [\(.subscriptionType)] \(.orgName)" else "logged out" end'
  printf '%-22s %s\n' '~/.claude' \
    "$(env -u CLAUDE_CONFIG_DIR claude auth status --json 2>/dev/null | jq -r "$fmt")"
  printf '%-22s %s\n' '~/.claude-finitec' \
    "$(CLAUDE_CONFIG_DIR="$CLAUDE_DIR_FINI" command claude auth status --json 2>/dev/null | jq -r "$fmt")"
  printf '%-22s %s\n' '~/.claude-lpp' \
    "$(CLAUDE_CONFIG_DIR="$CLAUDE_DIR_LPP" command claude auth status --json 2>/dev/null | jq -r "$fmt")"
}


# --- herdr: agent/session overview ---
# Defines hagents. Shows which pane holds which conversation and which panes
# would not survive a server restart.
source "$HOME/.config/zsh/herdr.zsh"
