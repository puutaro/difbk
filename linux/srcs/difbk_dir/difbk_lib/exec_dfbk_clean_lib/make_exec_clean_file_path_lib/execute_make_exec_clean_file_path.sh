#!/bin/bash


execute_make_exec_clean_file_path(){
	local exec_clean_file_path="${1}"
	echo "${clean_file_list_con}" \
		| sed -r 's/(.*)/"..\1'${DFBK_GGIP_EXETEND}'" \\/' \
		| sed -r '1~8s/(.*)/\& \n rm -rf \1/' \
		| sed \
			-e '$ s/\\$//' \
			-e '1s/\&//' \
		> "${exec_clean_file_path}"
	echo "${clean_file_list_con}" \
		| sed -r 's/(.*)/"..\1" \\/' \
		| sed -r '1~8s/(.*)/\& \n rm -rf \1/' \
		| sed \
			-e '$ s/\\$//' \
			-e '1s/\&//' \
		| sed "$ a sleep 5" \
		>> "${exec_clean_file_path}"
	wait 
}