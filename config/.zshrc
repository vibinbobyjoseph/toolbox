# ===== Homebrew PATH (Apple Silicon & Intel) =====
# Put Homebrew early in PATH no matter the CPU.
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ -d /usr/local/bin ]]; then
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# ===== Oh My Zsh =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""                      # Starship handles the prompt
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting fzf)
source "$ZSH/oh-my-zsh.sh"

# ===== Starship Prompt =====
# Fast, pretty, cross-shell prompt
# Point to custom config location
export STARSHIP_CONFIG="$HOME/Code/jcl/toolbox/config/starship.toml"
command -v starship >/dev/null && eval "$(starship init zsh)"

# ===== FZF (fuzzy finder) =====
# Keybindings & completion (installed by `fzf/install` step)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ===== FZF Enhanced Integration =====
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

if command -v bat >/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
fi

# Optional: nicer defaults without extra deps
export FZF_DEFAULT_OPTS="--height=40% --border --reverse --info=inline"

# ===== eza (modern ls) & common aliases =====
# Using Nerd Fonts for icons with WezTerm
if command -v eza >/dev/null; then
  alias ll='eza -lh --git --icons --group-directories-first'                    # long list
  alias la='eza -lah --git --icons --group-directories-first'                   # long list with hidden
  alias lt='eza --tree --level=2 --git --icons'                                 # tree view
  alias llt='eza -lh --git --tree --level=2 --icons --group-directories-first'  # long tree
fi

# ===== LazyGit =====
alias lg='lazygit'

# ===== Optional niceties =====
# Use bat as cat if installed
#if command -v bat >/dev/null; then
#  alias cat='bat'
#fi

# Safer rm/mv/cp
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias vi='nvim'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias myip="curl http://ipecho.net/plain; echo"
alias tm='open -a TextMate'
alias brewupdate='brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew doctor'

##billing alias
alias alertme="osascript -e 'display notification \"Build Finished\" with title \"Alert\"' && afplay /System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/ActionsAvailable.aiff"
alias exportgen="export MAVEN_OPTS=\"-Xms512m -Xmx24g\""
alias mvnut='exportgen && mvn -Punit-tests -Dskip.jacoco=true -DauditingOn=false clean test'
alias mvnq='time (exportgen && mvn -T12C -Paspectj clean install -Ddocker.skip -Ddependency-check.skip=true; alertme)'
alias mvnd='time (exportgen && mvn -T12C -Paspectj clean install -Ddependency-check.skip=true; alertme)'
alias mvnp='mvn -s ~/.m2/settings-p.xml ';
#alias gendb='cd ~/Documents/code/code-si/billing/billing-data-populator && mvn exec:java -DlocalMode=true -Duser.timezone=Europe/London -DdatabaseName=billing_temp -DdatabasePort=3338; alertme'
alias cddb='cd ~/Code/si/elevate/billing/billing-database/src/main/resources/db/billing'
#alias docker-compose='docker compose'

#utility server aliases
alias int='awsi ssh int-utility-server'
alias prod='awsi ssh prod-utility-server'
alias uat='awsi ssh uat-utility-server'
alias cvt='awsi ssh cvt-utility-server'
alias onb='awsi ssh onb-utility-server'
alias dev='awsi ssh dev-utility-server'
alias stag='awsi ssh stag-utility-server'
alias ucbefore='awsi ssh uc-before-utility-server'
alias ucafter='awsi ssh uc-after-utility-server'
alias demo='awsi ssh demo-utility-server'

#Miscellaneous commands
alias awsi="/Users/vibin.joseph/Code/si/elevate/awsi/awsi.rb"
alias awslocal='aws --endpoint-url=http://localhost:4566'
alias awsp='aws --profile personal'
alias amq='docker run -d --rm -it -p 61617:61616 -p 8162:8161 symptoma/activemq:latest'
alias ecrlogin='aws ecr get-login-password --region eu-west-2 --profile billing-prod | docker login --username AWS --password-stdin 257041628308.dkr.ecr.eu-west-2.amazonaws.com'

# ===== Billing Scripts  =====
source /Users/vibin.joseph/Code/si/elevate/billing_scripts/dockerdb.sh
source /Users/vibin.joseph/Code/si/elevate/billing_scripts/run_java_projects.sh

# ===== History settings =====
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY EXTENDED_HISTORY

# ===== Completion & quality-of-life =====
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colorize completion listings
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

setopt AUTO_CD AUTO_MENU AUTO_PARAM_SLASH COMPLETE_IN_WORD NO_CLOBBER
unsetopt BEEP

# ===== Git shortcuts =====
alias gs='git status -sb'
alias ga='git add -A'
alias gc='git commit'
alias gp='git push'
alias gl='git pull --rebase'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch -vv'

# ===== Editor & locale =====
export EDITOR="nano"      # or "vim", "nvim", "code -w"
export LC_ALL="en_GB.UTF-8"
export LANG="en_GB.UTF-8"

# ===== WezTerm nicety: report current dir (helps with tab titles) =====
# WezTerm auto-detects cwd in most cases; this keeps titles tidy on cd
function chpwd() { print -Pn "\e]7;file://$HOST$PWD\a" }

# ===== Final prompt newline preference =====
# Starship adds a newline by default; if you prefer no extra line:
# (set in ~/.config/starship.toml -> `add_newline = false`)

# ===== For Claude to work  =====
export PATH="$HOME/.local/bin:$PATH"

# ===== For AWSI to work  =====
PATH=$PATH:/usr/local/sessionmanagerplugin/bin:/opt/homebrew/opt/mysql-client/bin

# opencode
export PATH=/Users/vibin.joseph/.opencode/bin:$PATH

# ===== SDKMAN (Java Version Manager) =====
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# SDKMAN modifies PATH and needs to run after all other PATH modifications
export SDKMAN_OFFLINE_MODE=true
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
