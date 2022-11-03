#!/bin/bash
set -e

# init bukup before -----------------------------------------------------------------
if [ -e "${DFBK_CHECK_SUM_CULC_DIR_PATH}" ];then 
	rm -rf "${DFBK_CHECK_SUM_CULC_DIR_PATH}"
fi
if [ -e ${BUCKUP_DESC_TEMP_FILE_PATH} ];then rm ${BUCKUP_DESC_TEMP_FILE_PATH}; fi
if [ ! -e ${DFBK_IGNORE_FILE_PATH} ];then touch ${DFBK_IGNORE_FILE_PATH};fi
mkdir -p "${DFBK_CHECK_SUM_CULC_DIR_PATH}" &
rm -rf "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" \
		"${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" &
[ ! -e "${DFBK_LABEL_DIR_PATH}" ] && mkdir -p "${DFBK_LABEL_DIR_PATH}"
touch "${DFBK_LABEL_FILE_PATH}"
wait
# -----------------------------------------------------------------------------------

# option analysis -------------------------------------------------------------------
edit_desk_code="${DN_OPTION}"
edit_desk_contents="${DIFBK_ARGUMENT}"
# echo GENERAL_OPTION
IFS=$','
GENERAL_OPTION_LIST_CON=$(echo "${GENERAL_OPTION}" | tr ',' '\n' | gsed '/^$/d')
# echo GENERAL_OPTION_LIST_CON
# echo "${GENERAL_OPTION_LIST_CON}"
full_option=$(echo "${GENERAL_OPTION_LIST_CON}" | rga -o "\-full")

# label option start ---------------------------------------------------------------
# mklabel forbidden follow char ", [, ], \, ?, ! 
mklabel="-mklabel"
mklabel_con=$(echo "${GENERAL_OPTION_LIST_CON}" | rga "\\${mklabel}" | gsed "s/${mklabel}//" | gsed "s/^\s*//" | gsed "s/\s*$//" | gsed -r "s/'(.*)'$/\1/" | rga -v '\\' | rga -v '["\]\[\?!]')
lslabel="-lslabel"
lslabel_con=$(echo "${GENERAL_OPTION_LIST_CON}" | rga "\\${lslabel}")
rmlabel="-rmlabel"
rmlabel_con=$(echo "${GENERAL_OPTION_LIST_CON}" | rga "\\${rmlabel}" | gsed "s/${rmlabel}//" | gsed "s/^\s*//" | gsed "s/\s*$//" | gsed -r "s/'(.*)'$/\1/")
label_option_exec=0
label_check_con=$(echo -e "${mklabel_con}\n${lslabel_con}\n${rmlabel_con}" | gsed '/^$/d')
echo "${label_check_con}" | wc -l | \
[ $(cat) -gt 1 ] && echo "label option num must be one" && exit 0 || label_option_exec=1
case "${label_check_con}" in "") label_option_exec=0;; esac
case "${mklabel_con}" in 
	"");; 
	*) 
		if [ ! -e "${DFBK_LABEL_FILE_PATH}" ] || [ ! -s "${DFBK_LABEL_FILE_PATH}" ];then 
			echo "${mklabel_con}" > "${DFBK_LABEL_FILE_PATH}"
		else 
			mklabel_con=$(echo "${mklabel_con}" | gsed -r 's/([^a-zA-Z0-9_])/\\\1/g' )
			gsed "1i ${mklabel_con}" -i "${DFBK_LABEL_FILE_PATH}"
		fi
	;;
esac
case "${rmlabel_con}" in 
	"");; *) 
			sed_rmlabel_con=$(echo "${rmlabel_con}" | gsed -r 's/([\\])/\\\\\\\1/g' | gsed -r "s/([^a-zA-Z0-9_'\#\)\(\|\{\}\+\;\:\<\>])/\\\\\1/g")
			rm_after_con=$(cat "${DFBK_LABEL_FILE_PATH}" | gsed "s/^${sed_rmlabel_con}$//g" | gsed '/^$/d') 
			echo "${rm_after_con}" > "${DFBK_LABEL_FILE_PATH}"
			wait ;;esac
case "${lslabel_con}" in 
	"");; *) cat "${DFBK_LABEL_FILE_PATH}";;esac
# echo --
# echo "exist_merge_list: ${exist_merge_list}"
# echo "edit_desk_code: ${edit_desk_code}"
# echo "edit_desk_contents: ${edit_desk_contents}"
# echo "full_option: ${full_option}"
# echo "mklabel_con: ${mklabel_con}"
# echo "lslabel_con: ${lslabel_con}"
# echo "rmlabel_con: ${rmlabel_con}"
# echo "label_option_exec: ${label_option_exec}"
case "${label_option_exec}" in "1") exit 0;;esac
# -----------------------------------------------------------------------------------
# checksum culc for all current files (exclude difbk_ignore path on the way) -------- 
eval "fd -IH $(cat "${DFBK_IGNORE_FILE_PATH}" | rga -v "^#" | gsed -e 's/\[/\\\[/g' -e 's/\]/\\\]/g' -re "s/^([^ ])/\/\1/" -re "s/([^ ])$/\1/" -e 's/\/\//\//' -re 's/^([^ ])/ -E\ \1/' | tr -d '\n') . \"${TARGET_DIR_PATH}\"" | rga -v "/${DFBK_SETTING_DIR_NAME}" | gsed "1i ${TARGET_DIR_PATH}" | rga -v "${DFBK_IGNORE_FILE_NAME}$" | rga -v "${DIFBK_EXCLUDE_DS_STORE}$" > ${DFBK_CUR_FD_CON_FILE_PATH} && cat "${DFBK_CUR_FD_CON_FILE_PATH}" | gsed -e '/^$/d' -e "s/^/\"/" -e "s/$/\" \\\\/" -e '1i sum \\' | awk -v DFBK_CHECK_SUM_CULC_DIR_PATH="${DFBK_CHECK_SUM_CULC_DIR_PATH}"  '(NR%50==0){$0=$0"\n""> ""\042"DFBK_CHECK_SUM_CULC_DIR_PATH"/ch_file_"int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)int(rand() * 100000)"\042"" &""\nsum ""\\"}{print}' | gsed -e "$ s/\\\\$/ > \"${SED_DFBK_CHECK_SUM_CULC_DIR_PATH}\"\/ch_file_${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM} \&/" -e '$ a wait' > "${DFBK_EXEC_SUM_FILE_PATH}" && LANG=C bash "${DFBK_EXEC_SUM_FILE_PATH}" 2>/dev/null && fd -t f . "${DFBK_CHECK_SUM_CULC_DIR_PATH}" | gsed -e '/^$/d' -e "s/^/\"/" -e "s/$/\" \\\\/" -e '1i cat \\' | awk -v DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH=${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH} '(NR%200==0){$0=$0"\n"">> ""\042"DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH"\042""\ncat ""\\"}{print}' | sed "$ s/\\\\$/ >> \"${SED_DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}\"/" > "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" && bash "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" &
# -----------------------------------------------------------------------------
#list check if no list, fact dire search -------------------------
if [ -e "${BUCK_UP_DIR_PATH}" ];then
	merge_list_file_path=$(fd . "${BUCK_UP_DIR_PATH}" -d 6 | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | tail -n 1)
fi
#lecho "${merge_list_file_path}"
exist_merge_list=0
case "${merge_list_file_path}" in 
	"");;
	*)
		if [ -e "${merge_list_file_path}" ];then 
			LS_BACKUP_DIR_CONTENTS=$(gzcat "${merge_list_file_path}" | sed '/^$/d')
			row_num_merge_list_file=$(echo "${LS_BACKUP_DIR_CONTENTS}" | wc -l | gsed 's/\ //g')
			[ ${row_num_merge_list_file} -ge 1 ] && exist_merge_list=1
		fi
	;;
esac
# -----------------------------------------------------------------

# judge fullbackup (when recent merge list is none)
case "${full_option}" in "-full") exist_merge_list=0;; esac 
case "${exist_merge_list}" in 
	"0") 
		if [ ! -d "${BUCK_UP_DIR_PATH}" ]; then mkdir -p "${BUCK_UP_DIR_PATH}"; fi
		LS_BACKUP_DIR_CONTENTS="";;
esac
if [ ! -d ${DFBK_SETTING_DIR_PATH}  ];then mkdir -p ${DFBK_SETTING_DIR_PATH}; fi
if [ ! -d "${BUCK_UP_DIR_PATH}" ]; then mkdir -p "${BUCK_UP_DIR_PATH}"; fi
# ----------------------------------------------------------------------------

# when description edit is on ------------------------------------------------
after_desc_contents=""
case "${edit_desk_code}" in 
	"")
		if [ -e ${BUCKUP_DESC_FILE_PATH} ];then 
			before_desc_contents=$(cat ${BUCKUP_DESC_FILE_PATH})
			cp ${BUCKUP_DESC_FILE_PATH} ${BUCKUP_DESC_TEMP_FILE_PATH}
		fi
		case "${LN_OPTION}" in 
			"")
				label_con=$(cat "${DFBK_LABEL_FILE_PATH}")
				case "${label_con}" in "");;
					*)
						stamp_label=$(bash "${DIFBK_EXEC_LABEL_SELECT_FILE_PATH}" "${DFBK_LABEL_FILE_PATH}")
					;; 
				esac
				;;
			*)	;;
		esac
		case "${edit_desk_contents}" in 
			"") 
				[ -n "${stamp_label}" ] && echo "${stamp_label}" > ${BUCKUP_DESC_TEMP_FILE_PATH}
				nano ${BUCKUP_DESC_TEMP_FILE_PATH};;
			*) 	
				if [ -n "${stamp_label}" ] ;then 
					sed_stamp_label=$(echo "${stamp_label}" | gsed -r 's/([^a-zA-Z0-9_])/\\\1/g')
					# echo sed_stamp_label ${sed_stamp_label}
					edit_desk_contents=$(echo "${edit_desk_contents}" |\
					 gsed "1s/^/${sed_stamp_label}/")
				fi
				echo "${edit_desk_contents}" > "${BUCKUP_DESC_TEMP_FILE_PATH}"
				;;
		esac
		if [ ! -e ${BUCKUP_DESC_TEMP_FILE_PATH} ] || [ -z "$(cat "${BUCKUP_DESC_TEMP_FILE_PATH}" | gsed 's/\s//g' | sed '/^$/d')" ] ; then exit 0 ;fi
		after_desc_contents=$(cat ${BUCKUP_DESC_TEMP_FILE_PATH})
		if [ -n "$(echo "${before_desc_contents}")" ] && [ -n "$(echo "${after_desc_contents}")" ] && [  "$(echo "${before_desc_contents}")" == "$(echo "${after_desc_contents}")" ];then exit 0;fi
		;;
esac
# -----------------------------------------------------------------------------

# lecho "### bk:-2: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "### bk:-2: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | wc -l | sed 's/\ //g' || e=$?)"

wait
# culc current file contents ----------------------------------------------------
ls_current_dir_contents=$(cat <(join -v 1 <(cat "${DFBK_CUR_FD_CON_FILE_PATH}" | gsed -e 's/\ /'${DIFBK_BLANK_MARK}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) <(cat "${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}"  | gsed -re 's/^([0-9]{1,100})\ */\1\t/' -e 's/\ /\t/' | cut -f3 | sed 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) | gsed -e 's/'${DIFBK_BLANK_MARK}'/\ /g' -e 's/^/'${CHECH_SUM_DIR_INFO}'\t/') <(cat "${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}"  | gsed -re 's/^([0-9]{1,100})\ */\1\t/' -e 's/\ /\t/' | cut -f1,3) | sed 's/'${SED_TARGET_PAR_DIR_PATH}'//g' | sort -k 2,2)

# cat "${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}"  | gsed -r 's/^([0-9]{1,100})\ */\1\t/' | gsed 's/\ /\t/' | cut -f1,3
rm -rf "${DFBK_CHECK_SUM_CULC_DIR_PATH}" && 
mkdir -p "${DFBK_CHECK_SUM_CULC_DIR_PATH}" &
rm -rf  "${DFBK_CHECK_SUM_CULC_DIR_PATH}" \
		"${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" \
		"${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" &
# -------------------------------------------------------------------------------
# echo "ls_current_dir_contents:-5: $(echo "${ls_current_dir_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "ls_current_dir_contents:-5: $(echo "${ls_current_dir_contents}" | wc -l)"
# echo "### bk:-1: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | head -n ${DISPLAY_NUM_LIST})"
# echo "### bk:-1: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | wc -l | sed 's/\ //g')"

ls_backup_dir_c_for_diff=$(echo "${LS_BACKUP_DIR_CONTENTS}" | sed 's/\t\/'${BUCK_UP_DIR_NAME}'\/[0-9]\{4\}\/[0-9]\{2\}\/[0-9]\{2\}\/[0-9]\{4\}\/'${BACKUP_CREATE_DIR_NAME}'/\t/')
# echo "### bk:0: ls_backup_dir_c_for_diff: $(echo "${ls_backup_dir_c_for_diff}" | rga "flywheel/auth0/__init__.py" | head -n ${DISPLAY_NUM_LIST})"
# echo "### bk:0: ls_backup_dir_c_for_diff: $(echo "${ls_backup_dir_c_for_diff}" | wc -l | sed 's/\ //g')"

# create and delete list make ----------------------------------------------------
ls_create_buckup_merge_contents=$(join -v 1  <(echo "${ls_current_dir_contents}" | sed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort ) <(echo "${ls_backup_dir_c_for_diff}" | sed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) | sed -e 's/'${SED_TTTTBBBB}'\//\t\//g' -e 's/'${SED_TTTTBBBB}'\ $/\t\//g' -e 's/'${DIFBK_BLANK_MARK}'/\ /g')
ls_delete_buckup_merge_contents=$(join -v 2  <(echo "${ls_current_dir_contents}" | sed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) <(echo "${ls_backup_dir_c_for_diff}" | sed -e 's/\t/'${SED_TTTTBBBB}'/g' -e 's/\ /'${DIFBK_BLANK_MARK}'/g' | sort) | sed -e 's/'${SED_TTTTBBBB}'\//\t\//g' -e 's/'${SED_TTTTBBBB}'\ $/\t\//g' -e 's/'${DIFBK_BLANK_MARK}'/\ /g' -e '/^$/d')
ls_buckup_merge_contents="${LS_BACKUP_DIR_CONTENTS}"
# --------------------------------------------------------------------------------
# echo "bk:1: BACKUP_CREATE_DIR_PATH: ${BACKUP_CREATE_DIR_PATH}"
# echo "bk:1: BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH: ${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH}" | head -n ${DISPLAY_NUM_LIST}
# echo "bk:1: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:1: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# echo "bk:0: ### ls_delete_buckup_merge_contents: $(echo "${ls_delete_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:0: ### ls_delete_buckup_merge_contents: $(echo "${ls_delete_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# echo "bk:1: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:1: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"

# current files list decrease by crate and delete list ------------------------------------
#ls_buckup_merge_contents=$(remove_row_path_from_contents_eval_big "${ls_delete_buckup_merge_contents}" "${ls_buckup_merge_contents}")
case "${ls_delete_buckup_merge_contents}" in "");; 
	*)
		delete_list_mark="DLDLDLDLDLDLDL"
		ls_buckup_merge_contents=$(cat <(echo "${ls_delete_buckup_merge_contents}" | gsed -r "s/^([0-9d]{1,20})\t/\1\t${delete_list_mark}\t/") <(echo "${ls_buckup_merge_contents}" | gsed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2\t\3/") | sort -k 3 | uniq -u -f 2 | rga -v "[0-9d]{1,20}\t${delete_list_mark}\t" | sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\1\t\2\3/")
	;;
esac
# echo "bk:1.4: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:1.4: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')" 
case "${ls_create_buckup_merge_contents}" in "");; 
	*)
		create_list_mark="CCCCCCCCCC"
		ls_buckup_merge_contents=$(cat <(echo "${ls_create_buckup_merge_contents}" | gsed -r "s/^([0-9d]{1,20})\t/\1\t${create_list_mark}\t/") <(echo "${ls_buckup_merge_contents}" | gsed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})(.*)/\1\t\2\t\3/") | sort -k 3 | uniq -u -f 2 | rga -v "[0-9d]{1,20}\t${create_list_mark}\t" | sed -r "s/^([0-9d]{1,20})\t(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\t(.*)/\1\t\2\3/")
	;;
esac
# ------------------------------------------------------------------------
# echo "bk:1.5: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:1.5: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# ls_buckup_merge_contents=$(remove_row_path_from_contents_eval_big "${ls_create_buckup_merge_contents}" "${ls_buckup_merge_contents}")
# lecho "bk:1.5: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# lecho "bk:1.5: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# insert create list(by path change) -------------------------------------
insert_row_path_from_contents "${ls_buckup_merge_contents}"  "${ls_create_buckup_merge_contents}"
case "${INSERTED_CONTENTS}" in "");; *) ls_buckup_merge_contents="${INSERTED_CONTENTS}";; esac
# ------------------------------------------------------------------------

# echo "bk:2: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST})"
# echo "bk:2: ### ls_buckup_merge_contents: $(echo "${ls_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# echo "bk:2: ### ls_delete_buckup_merge_contents: $(echo "${ls_delete_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST}  | sort -k 2,2)"
# echo "bk:2: ### ls_delete_buckup_merge_contents: $(echo "${ls_delete_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
# echo "bk:2: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | head -n ${DISPLAY_NUM_LIST}  | sort -k 2,2)"
# echo "bk:2: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | wc -l | sed 's/\ //g')"
case "${ls_create_buckup_merge_contents}" in 
	"")
		echo "no buckup(create) target file"
		exit 0; 
	;;
esac

if [ ! -d ${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH} ];then mkdir -p ${BUCKUP_MERGE_CONTENSTS_LIST_DIR_PATH}; fi
# echo "bk:2: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | head -n 100)"
# echo "bk:2: ### ls_create_buckup_merge_contents: $(echo "${ls_create_buckup_merge_contents}" | wc -l | sed 's/\ //g')"

# when exist create, copy exec -------------------------------------
copy_exec "${ls_create_buckup_merge_contents}"
# -------------------------------------#----------------------------
wait


# when description create, mv it's file ------------------------------
# lecho "bk:2: BUCK_UP_CREATE_DIR_RALATIVE_PATH: ${BUCK_UP_CREATE_DIR_RALATIVE_PATH}"
# lecho "bk:2: TARGET_DIR_NAME: ${TARGET_DIR_NAME}"
echo "${ls_buckup_merge_contents}" > ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}
gzip ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH} && mv ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}${GGIP_EXETEND} ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_PATH}${DFBK_GGIP_EXETEND}
case "${after_desc_contents}" in "");;
	*)
		time_prefix=$(echo "${BUCKUP_DESC_FILE_PATH}" | gsed -e 's/'${SED_BUCK_UP_DIR_PATH}'\///' -e 's/\/'${BUCKUP_DESC_FILE_NAME}'//' -e 's/\//\\\//g')
		echo "$(echo ${after_desc_contents} | sed '1s/^/'${time_prefix}':\ /' | tr -d '\n')" > ${BUCKUP_DESC_FILE_PATH}
		;;
esac 
if [ -e ${BUCKUP_DESC_TEMP_FILE_PATH} ];then rm ${BUCKUP_DESC_TEMP_FILE_PATH}; fi
# --------------------------------------------------------------------

# output result ------------------------------------------------------
echo "${SEPARATE_BAR}"
case "${ls_delete_buckup_merge_contents}" in 
	"") delete_item_total=0 ;; 
	*) delete_item_total=$(echo "${ls_delete_buckup_merge_contents}" | wc -l | sed 's/\ //g')
		;;
esac
echo "delete_items total: ${delete_item_total}"
echo "$(echo "${ls_delete_buckup_merge_contents}" | cut -f2 | head -n ${DISPLAY_NUM_LIST})"
case "${ls_create_buckup_merge_contents}" in 
	"") create_item_total=0 ;; 
	*) create_item_total=$(echo "${ls_create_buckup_merge_contents}" | wc -l | sed 's/\ //g')
		;;
esac
echo "create_items total: ${create_item_total}"
echo "${ls_create_buckup_merge_contents}" | cut -f2 | head -n ${DISPLAY_NUM_LIST}
# --------------------------------------------------------------------
exit 0
