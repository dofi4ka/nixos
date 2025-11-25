# ------------------------
# Минималистичный Zsh
# ------------------------

# Пути и история
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST=5000

# Используем UTF-8
export LANG=en_US.UTF-8

# ------------------------
# PROMPT
# ------------------------
# Для nerd fonts можно просто вставить иконки
# Пример минималистичного промпта:
autoload -Uz colors && colors
setopt PROMPT_SUBST

PROMPT='%F{cyan}%n%f@%F{yellow}%m%f %F{green}%~%f $(git_prompt_info) %# '

# Функция для git статуса (минималистично)
git_prompt_info() {
  ref=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -n $ref ]] && echo " $ref"
}

# ------------------------
# Автодополнение
# ------------------------
autoload -Uz compinit
compinit

# ------------------------
# История
# ------------------------
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

# ------------------------
# Алиасы
# ------------------------
alias ll='ls -lh --color=auto'
alias la='ls -lha --color=auto'

# ------------------------
# Загрузка nerd fonts (если нужны специальные иконки)
# ------------------------
# Обычно достаточно, чтобы терминал сам использовал шрифт с поддержкой иконок
