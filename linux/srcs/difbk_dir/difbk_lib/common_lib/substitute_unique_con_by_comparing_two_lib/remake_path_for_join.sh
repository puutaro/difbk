#!/bin/bash


remake_path_for_join(){
	local path_ls="${1}"
	echo "${path_ls}" \
		| sed \
			-e 's/\t/'${SED_TTTTBBBB}'/g' \
			-e 's/\ /'${DIFBK_BLANK_MARK}'/g' \
		| sort
}