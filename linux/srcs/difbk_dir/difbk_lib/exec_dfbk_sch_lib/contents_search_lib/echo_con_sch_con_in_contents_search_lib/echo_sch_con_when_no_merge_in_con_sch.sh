#!/bin/bash


echo_sch_con_when_no_merge_in_con_sch(){
	local after_before="${1}"
	paste \
		<(\
	        echo "${TARGET_MERGE_LIST}" \
	        | sed -re "s/^(.*)/rga_con=\$(rga -z -a -n --heading ${RGA_OPTION[@]}  ${after_before} --color=ansi --colors 'path:fg:22' --colors 'match:fg:21' \"${DIFBK_SEARCH_WORD}\" \"\1\")\; case \"\${rga_con}\" in \"\")\;\; \*) echo \"\x1b[1;38;5;2m\${desk_con}\x1b[0m\"\; echo \"\${rga_con}\"\;\;esac /" \
	        | sed \
	          -r "s/(.*)/ \1/"\
	      ) \
		<(\
			echo "${DFBK_DESK_CAT_FILE_CON}" \
	        | sed \
	          -r 's/(.*)/desk_con="'${DESC_PREFIX}' \1"/'\
	  	) \
	| sed \
	    -r 's/(.*)\t(.*)/\2\n\1/'
}