#!/bin/bash
contents_search="-c"
contents_search_on=0
second_para="${2}"
third_para="${3}"
rm -rf "${DFBK_SCH_LIST_RECIEVE_DIR_PATH}"
mkdir "${DFBK_SCH_LIST_RECIEVE_DIR_PATH}"
DIFBK_SEARCH_WORD="${DIFBK_ARGUMENT}"

# optin analysis -------------------------------------------------
RGA_OPTION=($(echo "${GENERAL_OPTION//\,/$'\t'}"))
# echo C_OPTION $C_OPTION
# echo D_OPTION $D_OPTION
# echo DIFBK_SEARCH_WORD ${DIFBK_SEARCH_WORD}
# echo J_OPTION ${J_OPTION}
j_option_arg=$(echo ${J_OPTION} | sed  's/-j//' | sed  's/^\s*//')
case "${J_OPTION}" in "");; *) 
	case "${j_option_arg}" in "") echo "no exist j_option arg"; exit 0;;esac
	;; esac
# j_option_janre; 0 normal search 
# 1:certain generation num search 2:certain generation path search
j_option_janre=0
if [ -e "$(echo "${j_option_arg}" | rga "${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" )" ] ;then j_option_janre=2; fi
if [ ${j_option_janre} -eq 0 ];then
	expr "${j_option_arg}" + 1 >&/dev/null && j_option_janre=1 || e=$?
fi
# echo j_option_janre ${j_option_janre}
# -------------------------------------------------------------------------
case "${C_OPTION::2}" in
	"") DIFBK_SEARCH_WORD+="${V_OPTION} ${O_OPTION}";;
	"${contents_search}") contents_search_on=1 ;;
esac

rga_after_num="1"
# produce rga command ------------------------------------------------------
dRGA_OPTION=$(echo ${dRGA_OPTION} | sed  -re 's/-d([a-z]) /\ -\1\ /g')
desk_rga_cmd=$(make_desk_rga_comd "${rga_after_num}")
desk_rga_v_cmd=$(make_desk_rga_v_comd "${rga_after_num}")
# make before and after search cmd ---------------------------------------------------
before_and_after_delete_cmd=$(make_before_and_after_delete ${rga_after_num})
# --------------------------------------------------------------------------

# definition target_merge_list ---------------------------------------------------------------
case "${j_option_janre}" in 
	"0") # target_merge_list: DAY_DEPTH_PATH_LIST
		target_merge_list=$(fd -IH -t d . ${BUCK_UP_DIR_PATH} -d 5 | rga "[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BACKUP_CREATE_DIR_NAME}" | sort -r);;
	"1")
		target_merge_list_path="$(fd . "${BUCK_UP_DIR_PATH}" -d 6 | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort -r | sed  -n ''${j_option_arg}'p')"
		target_merge_list=$(zcat  "${target_merge_list_path}" | rga -v "${CHECH_SUM_DIR_INFO}" | cut -f2  | sed  's/^/'${SED_TARGET_PAR_DIR_PATH}'/' | sed  "s/$/${SED_DFBK_GGIP_EXETEND}/" | sed  "s/${SED_GGIP_EXETEND}${SED_DFBK_GGIP_EXETEND}$/${SED_GGIP_EXETEND}/" | sed  "s/\@${SED_DFBK_GGIP_EXETEND}$/\@/" | sort -r);;
	"2")
		target_merge_list_path="${j_option_arg}"
		target_merge_list=$(zcat  "${j_option_arg}" | rga -v "${CHECH_SUM_DIR_INFO}" | cut -f2 | sort -r);;
esac
# -----------------------------------------------------------------------------------------

# property serch word set -------------------------------------------------
case "${contents_search_on}" in 
	"1") 
		IFS=$'\t'
		DIFBK_SEARCH_WORD=($(echo ${DIFBK_SEARCH_WORD//\,/$'\t'} | sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g'))
		IFS=$' \n'
		LANG="ja_JP.UTF-8" contents_search; exit 0;;
esac
# -------------------------------------------------------------------------

# make rga cmd ------------------------------------------------------------
case "${DIFBK_SEARCH_WORD}" in 
	",\"\"") 
		rga_cmd=""
		;;
	"")
		rga_cmd="| rga ${RGA_OPTION[@]} "
		rga_cmd2="| rga --color=ansi --colors 'match:fg:21' ${RGA_OPTION[@]}"
		;;
	*)
		sed_rga_option=$(echo "${RGA_OPTION[@]}" | sed  -r 's/([^a-zA-Z0-9_])/\\\1/g')
		no_sed_rga_cmd=$(echo ${DIFBK_SEARCH_WORD}   | sed  "s/^,/ | rga ${sed_rga_option} /g" |  sed  "s/,/ | rga ${sed_rga_option} /g")
		rga_cmd=$(echo ${no_sed_rga_cmd} | sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g')
		rga_cmd2=$(echo ${DIFBK_SEARCH_WORD} | sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g' | sed  "s/^,/ | rga  --color=ansi --colors 'match:fg:21' ${sed_rga_option} /g" | sed  "s/,/ | rga  --color=ansi --colors 'match:fg:21' ${sed_rga_option} /g" | sed  -r 's/([^a-zA-Z0-9_-])/\\\1/g')
		;;
esac
# ------------------------------------------------------------------------------
# echo rga_cmd ${rga_cmd}
# echo rga_cmd2 ${rga_cmd2}
# echo ${DFBK_DESK_CAT_FILE_PATH}

# make desk cat file ----------------------------------------------------------------------
case "${j_option_janre}" in 
	"1"|"2") target_merge_list=$(echo "${target_merge_list}" | sed  -e 's/^'${SED_TARGET_PAR_DIR_PATH}'//' | sed  's/^\.\.//' | sed  's/^/../')
			target_merge_list=$(eval "echo \"${target_merge_list}\" ${no_sed_rga_cmd}")
		;; 
esac

DFBK_DESK_CAT_FILE_CON=$(desk_cat_func "${target_merge_list}")
# ------------------------------------------------------------------------------------------

sed_sed_target_par_path=$(echo "${TARGET_PAR_DIR_PATH}" | sed  -r 's/([^a-zA-Z0-9_])/\\\\\\\1/g')
# path list display -------------------------------------------------------------------------
case "${j_option_janre}" in 
	"1"|"2")
		sed_target_desk_con=$(cat "$(echo "${target_merge_list_path}" | sed   -e "s/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*/${BUCKUP_DESC_FILE_NAME}/")" | sed  -r 's/(.*)/(\1)/' | sed  -r 's/([^a-zA-Z0-9_])/\\\1/g')
		sch_paste_con=$(paste <(echo "${target_merge_list}" | sed  -re "s/^(.*)/echo \"\1\"/" -e "s/$/ | sed  -re \"s\/^\(.*\)\/echo \\\\\"\x1b[38;5;29m\${target_desk_con}\x1b[0m\\\\\"\\\\\; case \\\\\"\${desk_con}\\\\\" in \\\\\"\\\\\");; *) echo \\\\\"\x1b[1;38;5;2m\${desk_con}\x1b[0m\\\\\"\\\\\;\\\\\;esac ;echo \\\\\"\\\\t\\\\1\\\\\" ${rga_cmd2} \/e\" /") <(echo "${DFBK_DESK_CAT_FILE_CON}" | sed  -r 's/(.*)/desk_con=$(echo "'${DESC_PREFIX}' \1" | sed  -r "s\/([^a-zA-Z0-9_])\/\\\\\\\\\\1\/g")/') | sed  -r "s/(.*)\t(.*)/\2; target_desk_con=\$(echo \"${sed_target_desk_con}\" | sed  -r 's\/([^a-zA-Z0-9_])\/\\\\\\\\\\\\1\/g');\n\1/") 
		eval "echo \"\${sch_paste_con}\" ${desk_rga_cmd} ${desk_rga_v_cmd}  ${before_and_after_delete_cmd}" | sed  '/^--$/d' > "${DFBK_OUT_FD_LIST_FILE_PATH}"
		LANG="ja_JP.UTF-8" bash "${DFBK_OUT_FD_LIST_FILE_PATH}" 2>/dev/null | less -XR
		exit 0
		;;
esac

sch_paste_con=$(paste <(echo "${target_merge_list}" | sed  -re "s/^(.*)/fd -t f . \"\1\"/" -e "s/$/ ${rga_cmd} | sed  's\/^${sed_sed_target_par_path}\/\/' | sed  -e 's\/^\/..\/' -re \"s\/^\(.*\)\/case \\\\\"\${desk_con}\\\\\" in \\\\\"\\\\\");; *) echo \\\\\"\x1b[1;38;5;2m\${desk_con}\x1b[0m\\\\\"\\\\\;\\\\\;esac ;echo \\\\\"\\\\t\\\\1\\\\\" ${rga_cmd2} \/e\" /") <(echo "${DFBK_DESK_CAT_FILE_CON}" | sed  -r 's/(.*)/desk_con=$(echo "'${DESC_PREFIX}' \1" | sed  -r "s\/([^a-zA-Z0-9_])\/\\\\\\\\\\1\/g")/') | sed  -r 's/(.*)\t(.*)/\2\n\1/') 
eval "echo \"\${sch_paste_con}\" ${desk_rga_cmd} ${desk_rga_v_cmd} ${before_and_after_delete_cmd}" | sed  '/^--$/d' > "${DFBK_OUT_FD_LIST_FILE_PATH}"
wait 
LANG="ja_JP.UTF-8" bash "${DFBK_OUT_FD_LIST_FILE_PATH}"  | less -XR
# --------------------------------------------------------------------------------------
