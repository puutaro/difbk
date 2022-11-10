#!/bin/bash


echo_second_para(){
	local difbk_argument="${1}"
	local second_para_source=$(\
		echo "${difbk_argument}" \
		| sed 's/[",]//g'\
	)
	case "${second_para_source}" in
		"")
			echo "${MERGE_LIST_SECONDS_ORDER}"
			return
			;;
	esac
	echo "${second_para_source}"
}