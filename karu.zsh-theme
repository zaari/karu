
# Executed before each prompt
precmd() {
  # Main prompt
  [[ $EUID == 0 ]] && local karu_privilege_char='×' || local karu_privilege_char='»'
  local karu_exit_color="%(?.${KARU_THEME_LEFT_PROMPT_COLOR}.${KARU_THEME_ERROR_COLOR})"  
  PROMPT="${karu_exit_color}${karu_privilege_char} %b%f"
  
  # Right prompt
  RPROMPT="${KARU_THEME_RIGHT_PROMPT_COLOR}$(git_prompt_info)%b%f"
}

ZSH_THEME_GIT_PROMPT_PREFIX=
ZSH_THEME_GIT_PROMPT_SUFFIX=
ZSH_THEME_GIT_PROMPT_DIRTY="•"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

KARU_THEME_LEFT_PROMPT_COLOR="%B%F{blue}"
KARU_THEME_RIGHT_PROMPT_COLOR="%B%F{blue}"
KARU_THEME_ERROR_COLOR="%B%F{red}"

