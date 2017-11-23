
# Current working directory for the prompt
karu_theme_dir() {
  if [[ "$KARU_THEME_SHOW_DIR" != "0" ]] ; then
    if [[ "$(pwd)" != "$HOME" ]] ; then
      echo -n "%."
    fi
  fi
}

# Privilege symbol
karu_theme_privilege_symbol() {
  if [[ $EUID == 0 ]] ; then
    echo -n "×"
  else
    stat_ret=( $(stat -Lc "%a %G %U" "`pwd`") )
    local stat_perm=${stat_ret[1]}
    local stat_owner=${stat_ret[3]}

    if [[ $(( $stat_perm[-1] & 2 )) != 0 ]]; then
      echo -n "«"
    elif [[ $stat_owner == $USER ]] ; then
      echo -n "»"
    else
      echo -n "›"
    fi
  fi
}

karu_theme_git_symbol() {
  local branch_name="$(git_current_branch)"
  if [[ "${branch_name}" != "" ]] ; then
    if [[ -n "$(command git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
      echo -n " $ZSH_THEME_GIT_PROMPT_AHEAD "
    elif [[ -n "$(command git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
      echo -n " $ZSH_THEME_GIT_PROMPT_BEHIND "
    else
      if [[ "$KARU_THEME_SHOW_DIR" != "0" ]] ; then
        ZSH_THEME_GIT_PROMPT_CLEAN=" · "
      else
        ZSH_THEME_GIT_PROMPT_CLEAN=""
      fi 
      echo -n "$(parse_git_dirty)"
    fi
    echo "${branch_name}"
  else
  fi
}

# Executed before each prompt
precmd() {
  # Updste terminal title (useful on remote hosts)
  print -Pn "\e]0;%n@%m:%/\a"  

  # Main prompt (PS1)
  local karu_exit_color="%(?.${KARU_THEME_LEFT_PROMPT_COLOR}.${KARU_THEME_ERROR_COLOR})"  
  PROMPT="${karu_exit_color}$(karu_theme_privilege_symbol) %b%f"

  # Right prompt
  RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(karu_theme_dir)$(karu_theme_git_symbol)%b%f"
}

ZSH_THEME_GIT_PROMPT_PREFIX=
ZSH_THEME_GIT_PROMPT_SUFFIX=
ZSH_THEME_GIT_PROMPT_DIRTY=" × "
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"

# User-defineable variables
(( ${+KARU_THEME_LEFT_PROMPT_COLOR}  )) || KARU_THEME_LEFT_PROMPT_COLOR="%B%F{blue}"
(( ${+KARU_THEME_RIGHT_PROMPT_COLOR} )) || KARU_THEME_RIGHT_PROMPT_COLOR="%B%F{blue}"
(( ${+KARU_THEME_ERROR_COLOR}        )) || KARU_THEME_ERROR_COLOR="%B%F{red}"
(( ${+KARU_THEME_SHOW_DIR}           )) || KARU_THEME_SHOW_DIR=1

