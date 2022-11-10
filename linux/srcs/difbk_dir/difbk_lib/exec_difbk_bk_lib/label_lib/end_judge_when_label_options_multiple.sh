#!/bin/bash


end_judge_when_label_options_multiple(){
	local label_check_con=$(\
		echo -e "${MKLABEL_CON:-}\n${LSLABEL_CON:-}\n${RMLABEL_CON:-}" \
		| sed '/^$/d' \
	)
	echo "${label_check_con}" \
		| wc -l \
		| [ $(cat) -gt 1 ] \
			&& echo "label option num must be one" \
			&& exit 0 \
		|| e=$?
}