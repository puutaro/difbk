#!/bin/bash


echo_sch_paste_con_when_no_merge_list_path_and_num(){
	local RGA_CMD="${1}"
	local RGA_CMD2="${2}"
	local sed_target_par_path="${3}"
	paste \
		<(\
			echo "${TARGET_MERGE_LIST}" \
			| sed \
				-re "s/^(.*)/fd -t f . \"\1\"/" -e "s/$/ ${RGA_CMD} | sed  's\/^${sed_target_par_path}\/\/' | sed  -e 's\/^\/..\/' -re \"s\/^\(.*\)\/case \\\\\"\${desk_con}\\\\\" in \\\\\"\\\\\");; *) echo \\\\\"\x1b[1;38;5;2m\${desk_con}\x1b[0m\\\\\"\\\\\;\\\\\;esac ;echo \\\\\"\\\\t\\\\1\\\\\" ${RGA_CMD2} \/e\" /"\
		) \
		<(\
			echo "${DFBK_DESK_CAT_FILE_CON}" \
			| sed \
				-r 's/(.*)/desk_con=$(echo "'${DESC_PREFIX}' \1" | sed  -r "s\/([^a-zA-Z0-9_])\/\\\\\\\\\\1\/g")/'\
		) \
	| sed  -r 's/(.*)\t(.*)/\2\n\1/'
}