#!/bin/zsh

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[yellow]%}git("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=")*"
ZSH_THEME_GIT_PROMPT_CLEAN=")"

: ${ZSH_THEME_DIR_COLOR:='$fg_no_bold[cyan]'}
: ${ZSH_THEME_SHOW_HOST:=false}

function _set_user_prompt() {
	local ret_status='%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)%{$reset_color%}'

	local user_and_host='%(!:%{$fg[magenta]%}:%{$fg[green]%})%n'
	if [[ "$ZSH_THEME_SHOW_HOST" == true ]]; then
		user_and_host+='@%m'
	fi

	PROMPT="${ret_status} ${user_and_host}:%{$ZSH_THEME_DIR_COLOR%}%2~%{$reset_color%} \$(git_prompt_info)"
}

_set_user_prompt
