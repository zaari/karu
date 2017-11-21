
# Executed before each prompt
precmd() {
  # Main prompt
  [[ $EUID == 0 ]] && local karu_privilege_char='×' || local karu_privilege_char='»'
  local karu_exit_color="%(?.${KARU_THEME_LEFT_PROMPT_COLOR}.${KARU_THEME_ERROR_COLOR})"  
  PROMPT="${karu_exit_color}${karu_privilege_char} %b%f"
  
  # Right prompt
  local karu_git_current_branch="$(git_current_branch)"
  if [[ "${karu_git_current_branch}" != "" ]] ; then
    RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(basename `pwd`)$(parse_git_dirty)${karu_git_current_branch}%b%f"
  else
    RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(basename `pwd`)%b%f"
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX=
ZSH_THEME_GIT_PROMPT_SUFFIX=
ZSH_THEME_GIT_PROMPT_DIRTY=" : " # ×
ZSH_THEME_GIT_PROMPT_CLEAN=" · "

[ -n "KARU_THEME_LEFT_PROMPT_COLOR" ] && KARU_THEME_LEFT_PROMPT_COLOR="%B%F{blue}"
[ -n "KARU_THEME_RIGHT_PROMPT_COLOR" ] && KARU_THEME_RIGHT_PROMPT_COLOR="%b%F{017}" # 237
[ -n "KARU_THEME_ERROR_COLOR" ] && KARU_THEME_ERROR_COLOR="%B%F{red}"

