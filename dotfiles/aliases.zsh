# ---------- Optional tool aliases ----------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons'
  alias la='eza -a --icons'
  alias lt='eza --tree --icons --level=2'
fi

if command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
  alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

if command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

# ---------- shortcuts ----------
alias c='clear'
alias cls='clear'
alias sysinfo='fastfetch'

# ---------- Git ----------
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
