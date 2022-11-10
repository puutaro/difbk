#!/bin/bash


desk_cat_func(){
	local LANG=C
	local dfbk_desk_cat_file_path="${DFBK_SETTING_DIR_PATH}/desk_cat.sh"
	local dfbk_desk_recieve_dir_path="${DFBK_SETTING_DIR_PATH}/desk_recieve"
	local dfbk_desk_recieve_file_path="${DFBK_SETTING_DIR_PATH}/desk_recieve.sh"
	local dfbk_desk_output_file_path="${DFBK_SETTING_DIR_PATH}/desk_output.sh"
	rm -rf \
		"${dfbk_desk_recieve_dir_path}" \
		"${dfbk_desk_recieve_file_path}"
	mkdir -p "${dfbk_desk_recieve_dir_path}"
	sed_dfbk_desk_recieve_dir_path=$(\
		echo "${dfbk_desk_recieve_dir_path}" \
		| sed 's/\//\\\//g'\
	)
	sed_dfbk_desk_recieve_file_path=$(\
		echo "${dfbk_desk_recieve_file_path}" \
		| sed 's/\//\\\//g'\
	)
	# make desk cat file ----------------------------------------------------
	echo "${TARGET_MERGE_LIST}" \
	| sed \
		-e 's/'${BACKUP_CREATE_DIR_NAME}'.*/'${BUCKUP_DESC_FILE_NAME}'/' \
		-re 's/^(.*)/"\1" /' \
	| sed 's/$/ \\/' \
	| awk \
		-v dfbk_desk_recieve_dir_path="${dfbk_desk_recieve_dir_path}"  \
		'(\
			NR%50==0\
		){ \
			printf "%s\n >  ""\042"dfbk_desk_recieve_dir_path"/""desk_con_%024d""\042"" 2>&1 & \n head -qn 1 ",$0,NR
		}(\
			NR%50!=0\
		){
			print
		}' \
		| sed '1ihead -qn 1 \\' \
		| sed "$ s/\\\\$/ > \"${sed_dfbk_desk_recieve_dir_path}\/desk_con_9${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}\"  2\>\&1 \&/" \
		| sed '$ s/head -qn 1//' \
		| sed '$ a wait' \
			> "${dfbk_desk_cat_file_path}" \
	&& LANG=C bash "${dfbk_desk_cat_file_path}" \
	|| e=$?
	fd -t f . "${dfbk_desk_recieve_dir_path}" \
	| sed \
		-e '/^$/d' \
		-e "s/^/\"/" \
		-e "s/$/\" \\\\/" \
		-e '1i cat \\' \
	| awk \
		-v dfbk_desk_recieve_file_path=${dfbk_desk_recieve_file_path} \
		'(\
			NR%20==0\
		){
			$0=$0"\n;cat ""\\"
		}{
			print
		}' \
	| sed '$s/^\;cat \\//' \
		> "${dfbk_desk_output_file_path}" \
	&& bash "${dfbk_desk_output_file_path}" \
		| sed 's/.*No such\sfile\sor\sdirectory.*/-/'
}