#!/bin/bash


exec_substitute_unique_con(){
	local first_path_ls="${1}"
	local second_path_ls="${2}"
	local unique_order="${3}"
	join -v "${unique_order}" \
		<(echo "${first_path_ls}") \
		<(echo "${second_path_ls}") \
	| sed \
		-e 's/'${SED_TTTTBBBB}'\//\t\//g' \
		-e 's/'${SED_TTTTBBBB}'\ $/\t\//g' \
		-e 's/'${DIFBK_BLANK_MARK}'/\ /g' \
		-e '/^$/d'
}