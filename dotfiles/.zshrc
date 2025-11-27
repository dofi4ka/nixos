export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000

export LANG=en_US.UTF-8

autoload -Uz colors && colors
setopt PROMPT_SUBST

PROMPT='%F{cyan}%n%f@%F{yellow}%m%f %F{green}%~%f $(git_prompt_info) %# '

git_prompt_info() {
  ref=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -n $ref ]] && echo "󰊢 ($ref)"
}

# bindkey -v

autoload -Uz compinit
compinit

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'
