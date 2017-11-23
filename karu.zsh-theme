
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
  stat_ret=( $(stat -Lc "%a %G %U" "`pwd`") )
  local stat_perm=${stat_ret[1]}
  local stat_owner=${stat_ret[3]}
  if [[ $EUID == 0 ]] ; then
    echo -n "×"
  else
    if [[ $(( $stat_perm[-1] & 2 )) != 0 ]]; then
      echo -n "«"
    elif [[ $stat_owner == $USER ]] ; then
      echo -n "»"
    else
      echo -n "›"
    fi
  fi
}

# Executed before each prompt
precmd() {
  # Updste terminal title (useful on remote hosts)
  print -Pn "\e]0;%n@%m:%/\a"  

  # Main prompt (PS1)
  local karu_exit_color="%(?.${KARU_THEME_LEFT_PROMPT_COLOR}.${KARU_THEME_ERROR_COLOR})"  
  PROMPT="${karu_exit_color}$(karu_theme_privilege_symbol) %b%f"

  # Clean symbol
  [[ "$KARU_THEME_SHOW_DIR" != "0" ]] \
    && ZSH_THEME_GIT_PROMPT_CLEAN="· " \
    || ZSH_THEME_GIT_PROMPT_CLEAN="" 
  
  # Right prompt
  local karu_theme_current_branch="$(git_current_branch)"
  if [[ "${karu_theme_current_branch}" != "" ]] ; then
    RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(karu_theme_dir) $(parse_git_dirty)${karu_theme_current_branch}%b%f"
  else
    RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(karu_theme_dir)"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=
ZSH_THEME_GIT_PROMPT_SUFFIX=
ZSH_THEME_GIT_PROMPT_DIRTY="× "

# User-defineable variables
(( ${+KARU_THEME_LEFT_PROMPT_COLOR}  )) || KARU_THEME_LEFT_PROMPT_COLOR="%B%F{blue}"
(( ${+KARU_THEME_RIGHT_PROMPT_COLOR} )) || KARU_THEME_RIGHT_PROMPT_COLOR="%B%F{blue}"
(( ${+KARU_THEME_ERROR_COLOR}        )) || KARU_THEME_ERROR_COLOR="%B%F{red}"
(( ${+KARU_THEME_SHOW_DIR}           )) || KARU_THEME_SHOW_DIR=1

