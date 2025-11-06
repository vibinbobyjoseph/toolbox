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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)
source "$ZSH/oh-my-zsh.sh"

# ===== Starship Prompt =====
# Fast, pretty, cross-shell prompt
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
# If you use a Nerd Font, you can add --icons; leaving it off for compatibility
if command -v eza >/dev/null; then
  alias ll='eza -lh --git'                    # long list
  alias la='eza -lah --git'                   # long list with hidden
  alias lt='eza --tree --level=2 --git'       # tree view
  alias llt='eza -lh --git --tree --level=2'  # long tree
fi

# ===== LazyGit =====
alias lg='lazygit'

# ===== Optional niceties =====
# Use bat as cat if installed
if command -v bat >/dev/null; then
  alias cat='bat'
fi

# Safer rm/mv/cp
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'

# ===== History settings =====
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY EXTENDED_HISTORY

# ===== Completion & quality-of-life =====
autoload -Uz compinit && compinit -u

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

# ===== SDKMAN (Java Version Manager) =====
# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# SDKMAN modifies PATH and needs to run after all other PATH modifications
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
