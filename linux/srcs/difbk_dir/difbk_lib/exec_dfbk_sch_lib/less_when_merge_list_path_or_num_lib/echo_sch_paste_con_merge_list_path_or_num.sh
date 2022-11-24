#!/bin/bash


echo_sch_paste_con_merge_list_path_or_num(){
	local RGA_CMD2="${1}"
	local sed_target_desk_con="${2}"
	paste \
	<(\
		echo "${TARGET_MERGE_LIST}" \
		| sed  \
			-re "s/^(.*)/echo \"\1\"/" \
			-e "s/$/ | sed  -re \"s\/^\(.*\)\/echo \\\\\"\x1b[38;5;29m\${target_desk_con}\x1b[0m\\\\\"\\\\\; case \\\\\"\${desk_con}\\\\\" in \\\\\"\\\\\");; *) echo \\\\\"\x1b[1;38;5;2m\${desk_con}\x1b[0m\\\\\"\\\\\;\\\\\;esac ;echo \\\\\"\\\\t\\\\1\\\\\" ${RGA_CMD2} \/e\" /"\
	) \
	<(\
		echo "${DFBK_DESK_CAT_FILE_CON}" \
		| sed  -r 's/(.*)/desk_con=$(echo "'${DESC_PREFIX}' \1" | sed  -r "s\/([^a-zA-Z0-9_])\/\\\\\\\\\\1\/g")/'\
	) \
	| sed \
		-r "s/(.*)\t(.*)/target_desk_con=\$(echo \"${sed_target_desk_con}\" | sed  -r 's\/([^a-zA-Z0-9_])\/\\\\\\\\\\\\1\/g'); \2; \n\1/"
}