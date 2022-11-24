#!/bin/bash


echo_diff_paste_con_generation(){
	local sed_before_diff_label="${1}"
	paste \
		<(\
			echo "${diff_file_pair_con}" \
			| sed '1~2s/^/val2\=/' \
			| sed '0~2s/^/val1\=/'\
		) \
		<(\
			echo "${DFBK_DESK_CAT_FILE_CON}" \
			| sed \
				-re '1~2s/(.*)/desk_con2=$(echo "[2] '${DESC_PREFIX}' \1")/' \
				-re '0~2s/(.*)/desk_con1=$(echo "[1] \1")/'\
		) \
		| sed \
			-re 's/^(.*)\t(.*)$/\2\n\1/' \
			-e "1~2i diff_con=\$(colordiff -u <(zcat \"\${val2}\"  2>/dev/null || cat \"\${val2}\" 2>/dev/null) <(zcat \"\${val1}\" 2>/dev/null || cat \"\${val1}\" 2>/dev/null) | sed '1,2d'); case \"\${diff_con}\" in \"\") \;\; \*\) echo \"\x1b[1;38;5;94m[3] ${sed_before_diff_label}\x1b[0m\" && echo -e \"\x1b[38;5;88m\${desk_con2}\x1b[0m\\\\n\x1b[38;5;88m[2] \${val2}\x1b[0m\\\\n\x1b[38;5;2m\${desk_con1}\x1b[0m\\\\n\x1b[38;5;2m[1] \${val1}\x1b[0m\\\\n\${diff_con}\"\;\;esac " \
			-e "$ a diff_con=\$(colordiff -u <(zcat \"\${val2}\"  2>/dev/null || cat \"\${val2}\" 2>/dev/null) <(zcat  \"\${val1}\" 2>/dev/null || cat \"\${val1}\" 2>/dev/null)  | sed '1,2d'); case \"\${diff_con}\" in \"\"\)\;\; \*\) echo \"\x1b[1;38;5;94m[3] ${sed_before_diff_label}\x1b[0m\" && echo -e \"\x1b[38;5;88m\${desk_con2}\x1b[0m\\\\n\x1b[38;5;88m[2] \${val2}\x1b[0m\\\\n\x1b[38;5;2m\${desk_con1}\x1b[0m\\\\n\x1b[38;5;2m[1] \${val1}\x1b[0m\\\\n\${diff_con}\"\;\;esac " \
		| sed '1d' \
		| awk '(NR%5>1){printf "%s;",$0}(NR%5<=1){print $0}' \
		| sed -r \
			-e 's/;(;diff_con=)/\1/' \
			-e 's/^;(desk_con1=)/\1/' \
			-e '$ s/^;//'
}