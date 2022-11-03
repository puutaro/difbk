#!/bin/bash

# 0:path word 1;num 2:path 
second_para_janre=0
second_para=$(echo "${DIFBK_ARGUMENT}" | gsed 's/[",]//g')
if [ -z "${second_para}" ];then second_para=2;fi
if [ -e "$(echo "${second_para}" | rga "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" )" ] ;then second_para_janre=2 ; fi
if [ ${second_para_janre} -eq 0 ];then
	expr "${second_para}" + 1 >&/dev/null &&  second_para_janre=1 || e=$?
fi
recent_merge_list_path=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | tail -n 1)
# lecho "diff:1: recent_merge_list_path: ${recent_merge_list_path}"
if [ -z "$(echo "${recent_merge_list_path}")" ];then 
	echo "please command: difbk bk ( no exist merge list"
	exit 0
fi
# produce rga command
rga_after_num=1
dRGA_OPTION=$(echo ${dRGA_OPTION} | gsed -re 's/-d([a-z]) /\ -\1\ /g')
desk_rga_cmd=$(make_desk_rga_comd "${rga_after_num}" "diff")
desk_rga_v_cmd=$(make_desk_rga_v_comd "${rga_after_num}" "diff")
before_and_after_delete_cmd=$(make_before_and_after_delete ${rga_after_num} "diff")
if [ ${second_para_janre} -eq 0 ];then
	dat_depth_path_con=$(fd -IH -t d . ${BUCK_UP_DIR_PATH} -d 5 | rga "[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" | sort -r)
	IFS=$'\n'
	DAY_DEPTH_PATH_LIST=($(echo ${dat_depth_path_con}))
	RECENT_DAY_DEPTH_PATH_LIST=($(echo "${dat_depth_path_con}" | head -n 20))
	IFS=$' \n'
	
	read diff_target_file < <(fd -t f . "${RECENT_DAY_DEPTH_PATH_LIST[@]}" | gsed 's/^'${SED_BUCK_UP_DIR_PATH}'//' | rga "${second_para}" | sort -r | \
		fzf --cycle \
			--preview="echo {} | gsed 's/^/${SED_BUCK_UP_DIR_PATH}/' | gsed 's/'${BACKUP_CREATE_DIR_NAME}'.*/'${BUCKUP_DESC_FILE_NAME}'/' | gxargs -I{} cat {} | gsed 's/^/\[description\]\ /' " \
			--preview-window='wrap,down:3' \
		| gsed 's/^/\/'${BUCK_UP_DIR_NAME}'/')

	grep_path=$(echo "${diff_target_file}" | gsed 's/^\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'//')
	sed_diff_target_file=$(echo "${diff_target_file}" | gsed 's/\//\\\//g')
	diff_target_desk_file=$(echo "${diff_target_file}" | gsed -e 's/^/\.\./' -e "s/${BACKUP_CREATE_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/")
	sed_diff_target_desk_con=$(cat "${diff_target_desk_file}" 2>/dev/null || echo --)
	sed_diff_target_desk_con=$(echo "${sed_diff_target_desk_con}" | gsed -r 's/([^a-zA-Z0-9_ ])/\\\1/g')
	diff_target_file_path=$(fd -IH . ${DAY_DEPTH_PATH_LIST[@]} | rga "${grep_path}$"  | sort -r)
	DFBK_DESK_CAT_FILE_CON=$(desk_cat_func "${diff_target_file_path}")
	diff_paste_con=$(paste <(echo "${diff_target_file_path}" | gsed 's/'${SED_TARGET_PAR_DIR_PATH}'/../' | gsed -re 's/^(.*)/d_file2_path="\1"; diff_con=\$(colordiff -u  <(gzcat  "\1") <(gzcat  "'${SED_TARGET_PAR_DIR_PATH}''${sed_diff_target_file}'"))/' ) <(echo "${DFBK_DESK_CAT_FILE_CON}" | gsed -r 's/(.*)/desk_con2=$(echo "[2] '${DESC_PREFIX}' \1")/') | gsed "s/$/\tdesk_con1=\"\$(echo \"[1] ${DESC_PREFIX} ${sed_diff_target_desk_con}\" | gsed -r 's\/([^a-zA-Z0-9_])\/\\\\1\/g')\"/" | gsed -r 's/^(.*)\t(.*)\t(.*)$/\2;\3\;\1\ncase "${diff_con}" in "")\;\; \*) echo "\x1b[38;5;88m${desk_con2}\x1b[0m";echo "\x1b[38;5;88m[2] '\${d_file2_path}'\x1b[0m";echo "\x1b[38;5;2m${desk_con1}\x1b[0m";echo "\x1b[38;5;2m[1] ..'${sed_diff_target_file}'\x1b[0m";echo "${diff_con}";;esac/')
	eval "echo \"\${diff_paste_con}\" ${desk_rga_cmd} ${desk_rga_v_cmd} ${before_and_after_delete_cmd}" | gsed '/^--$/d' > "${DFBK_EXEC_DIFF_PATH}"
	LANG="ja_JP.UTF-8" bash "${DFBK_EXEC_DIFF_PATH}"  2>/dev/null  | less -XR
	exit 0
fi
if [ ${second_para_janre} -eq 1 ];then
	diff_e_option=$(echo "${GENERAL_OPTION}" | gsed 's/\,/\t/g' | rga -o -e "\t-e$" -e "\t-e\t")
	case "${diff_e_option}" in 
		"")
			before_merge_list_path=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort -r | gsed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" | uniq -f 1  | gsed -r "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/" | gsed -n ''${second_para}'p');;
		*)
			before_merge_list_path=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort -r | gsed -n ''${second_para}'p')
			;;
	esac
elif [ ${second_para_janre} -eq 2 ];then
  	before_merge_list_path=$(echo "${second_para}" | gsed 's/\.\./'${SED_TARGET_PAR_DIR_PATH}'/')
  	second_para="-"
fi
# lecho "diff:1: before_merge_list_path: ${before_merge_list_path}"
before_diff_compare_path=$(echo "${before_merge_list_path}" | rga -o "${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}" | gsed 's/$/\/'${BACKUP_CREATE_DIR_NAME}'\/'${TARGET_DIR_NAME}'\//')
if [ ! -e "${recent_merge_list_path}" ];then echo "no ${recent_merge_list_path}"; exit 0; fi
if [ ! -e "${before_merge_list_path}" ];then echo "no ${before_merge_list_path}"; exit 0; fi
# lecho "diff:1: ### recent_merge_list_path: $(gzcat  "${recent_merge_list_path}" | wc -l | gsed 's/\ //g')"
# lecho "diff:1: ### recent_merge_list_path: $(gzcat  "${recent_merge_list_path}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "diff:1: ### before_merge_list_path: $(gzcat  "${before_merge_list_path}" | wc -l | gsed 's/\ //g')"
# lecho "diff:1: ### before_merge_list_path: $(gzcat  "${before_merge_list_path}" | head -n ${DISPLAY_NUM_LIST})"
ls_create_buckup_merge_contents=$(join -v 1 <(gzcat  "${recent_merge_list_path}" | gsed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort ) <(gzcat  "${before_merge_list_path}" | gsed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) | gsed -e 's/'${SED_TTTTBBBB}'\//\t\//g' -e 's/'${DIFBK_BLANK_MARK}'/\ /g')
ls_delete_buckup_merge_contents=$(join -v 2 <(gzcat  "${recent_merge_list_path}" | gsed 's/\t/'${SED_TTTTBBBB}'/g' | sort) <(gzcat  "${before_merge_list_path}" | gsed 's/\t/'${SED_TTTTBBBB}'/g' | sort) | gsed -e 's/'${SED_TTTTBBBB}'\//\t\//g' -e 's/'${DIFBK_BLANK_MARK}'/\ /g' -e '/^$/d')
before_day_dir_path=$(echo "${before_merge_list_path}" | gsed -e 's/'${SED_TARGET_PAR_DIR_PATH}'/\.\./' -e 's/'${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}'.*//')
sed_before_day_dir_path=$(echo "${before_day_dir_path}" | gsed -r 's/([^a-zA-Z0-9_])/\\\1/g' )
sed_before_diff_label=$(echo "${before_day_dir_path}" | gsed 's/$/'${BUCKUP_DESC_FILE_NAME}'/' | cat $(cat) || echo --)
sed_before_diff_label=$(echo "${sed_before_diff_label}" | gsed -re "s/(.*)/(\1) ${sed_before_day_dir_path}/" -re 's/([^a-zA-Z0-9_])/\\\1/g')
# total fact diff culc
diff_file_pair_con=$(cat <(echo "${ls_create_buckup_merge_contents}"  | cut -f2 | rga -v "${CHECH_SUM_DIR_INFO}" | gsed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2/") <(echo "${ls_delete_buckup_merge_contents}" | cut -f2 | rga -v "${CHECH_SUM_DIR_INFO}" | gsed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2/")  | gsed 's/$/'${DFBK_GGIP_EXETEND}'/' | gsed "s/\.gz${SED_DFBK_GGIP_EXETEND}/\.gz/" | sort -k 2,2 | uniq -f 1 -D | gsed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\"..\1\2\"/")

# make desk
DFBK_DESK_CAT_FILE_CON=$(desk_cat_func "$(echo "${diff_file_pair_con}" | gsed -r 's/"(.*)"/\1/' | gsed 's/\.\./'${SED_TARGET_PAR_DIR_PATH}'/')")
diff_paste_con=$(paste <(echo "${diff_file_pair_con}" | gsed '1~2s/^/val2\=/' | gsed '0~2s/^/val1\=/') <(echo "${DFBK_DESK_CAT_FILE_CON}" | gsed -re '1~2s/(.*)/desk_con2=$(echo "[2] '${DESC_PREFIX}' \1")/' -re '0~2s/(.*)/desk_con1=$(echo "[1] \1")/') | gsed -re 's/^(.*)\t(.*)$/\2\n\1/' -e "1~2i diff_con=\$(colordiff -u <(gzcat  \"\${val2}\") <(gzcat  \"\${val1}\")); case \"\${diff_con}\" in \"\") \;\; \*\) echo \"\x1b[1;38;5;94m[3] ${sed_before_diff_label}\x1b[0m\" && echo -e \"\x1b[38;5;88m\${desk_con2}\x1b[0m\\\\n\x1b[38;5;88m[2] \${val2}\x1b[0m\\\\n\x1b[38;5;2m\${desk_con1}\x1b[0m\\\\n\x1b[38;5;2m[1] \${val1}\x1b[0m\\\\n\${diff_con}\"\;\;esac " -e "$ a diff_con=\$(colordiff -u <(gzcat  \"\${val2}\") <(gzcat  \"\${val1}\")); case \"\${diff_con}\" in \"\"\)\;\; \*\) echo \"${sed_before_diff_label}\" && echo -e \"\x1b[38;5;88m\[2\] \${desk_con2}\x1b[0m\\\\n\x1b[38;5;88m[2] \${val2}\x1b[0m\\\\n\x1b[38;5;2m\[1\] \${desk_con1}\x1b[0m\\\\n\x1b[38;5;2m[1] \${val1}\x1b[0m\\\\n\${diff_con}\"\;\;esac " | gsed '1d' | awk '(NR%5>1){printf "%s;",$0}(NR%5<=1){print $0}') 
eval "echo \"\${diff_paste_con}\" ${desk_rga_cmd} ${desk_rga_v_cmd}  ${before_and_after_delete_cmd}" | gsed '/^--$/d' > "${DFBK_EXEC_DIFF_PATH}"
LANG="ja_JP.UTF-8" bash "${DFBK_EXEC_DIFF_PATH}" | less -XR
exit 0
