#!/bin/bash


make_rga_cmd(){
	case "${DIFBK_SEARCH_WORD}" in 
	",\"\"") 
		RGA_CMD=""
		;;
	"")
		RGA_CMD="| rga ${RGA_OPTION[@]} "
		RGA_CMD2="| rga --color=ansi --colors 'match:fg:21' ${RGA_OPTION[@]}"
		;;
	*)
		local sed_rga_option=$(\
			echo "${RGA_OPTION[@]}" \
				| sed  -r 's/([^a-zA-Z0-9_])/\\\1/g'\
		)
		NO_SED_RGA_CMD=$(\
			echo ${DIFBK_SEARCH_WORD}  \
			| sed  "s/^,/ | rga ${sed_rga_option} /g" \
			|  sed  "s/,/ | rga ${sed_rga_option} /g"\
		)
		RGA_CMD=$(\
			echo ${NO_SED_RGA_CMD} \
			| sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g'\
		)
		RGA_CMD2=$(\
			echo ${DIFBK_SEARCH_WORD} \
				| sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g' \
				| sed  "s/^,/ | rga  --color=ansi --colors 'match:fg:21' ${sed_rga_option} /g" \
				| sed  "s/,/ | rga  --color=ansi --colors 'match:fg:21' ${sed_rga_option} /g" \
				| sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g'\
		)
		;;
	esac
}