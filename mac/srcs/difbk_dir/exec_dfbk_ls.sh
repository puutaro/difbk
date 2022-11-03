#!/bin/bash

less_swich=0
if [ -z "${2}" ];then DISPLAY_LIMIT=${DISPLAY_LIMIT_ABUSOLUTE};
elif expr "${2}" : "[0-9]*$" >&/dev/null;then DISPLAY_LIMIT=${2};
else RANDOM_SUPER_LIMIT=${DISPLAY_LIMIT_ABUSOLUTE}; fi
if [ -z "${3}" ];then RANDOM_SUPER_LIMIT=${RANDOM_SUPER_LIMIT_ABUSOLUTE};
elif expr "${3}" : "[0-9]*$" >&/dev/null;then RANDOM_SUPER_LIMIT=${3};
else RANDOM_SUPER_LIMIT=${RANDOM_SUPER_LIMIT_ABUSOLUTE}; fi
echo "${SEPARATE_BAR}"
ls_backup_dir_info=$(du -a ${BUCK_UP_DIR_PATH} | sed 's/'${SED_TARGET_PAR_DIR_PATH}'//g' | sort -k 2,2)
#ls_backup_dir_info=$(du -ba ${BUCK_UP_DIR_PATH} | sed 's/'${SED_TARGET_PAR_DIR_PATH}'//g'  )
lecho "### ls:1: ls_backup_dir_info: $(echo "${ls_backup_dir_info}" | head -n ${DISPLAY_NUM_LIST})"
lecho "### ls:1: ls_backup_dir_info: $(echo "${ls_backup_dir_info}" | wc -l | sed 's/\ //g')"
LS_BACKUP_DIR_CONTENTS=$(echo "${ls_backup_dir_info}" | grep -v "/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}" | grep "${BACKUP_CREATE_DIR_NAME}/" || e=$?)
lecho "### ls:1: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | head -n ${DISPLAY_NUM_LIST})"
lecho "### ls:1: LS_BACKUP_DIR_CONTENTS: $(echo "${LS_BACKUP_DIR_CONTENTS}" | wc -l | sed 's/\ //g')"
display_reverse_nl_line "${LS_BACKUP_DIR_CONTENTS}"
ls_display_content=$(echo "${LS_DISPLAY_CONTENT}")
ls_display_num=$(echo "${ls_display_content}" | wc -l | sed 's/\ //g')
ls_header=$(cat <(echo "${ls_header}") <(echo "HIT_NUM: ${ls_display_num}, DISPLAY_LIMIT: ${DISPLAY_LIMIT}, RANDOM_SUPER_LIMIT: ${RANDOM_SUPER_LIMIT}") <(echo "-> usecase ex) less {^path}, zdiff {^path} {^path}, bkep {keyword} {^path} (range(defo 2))") <(echo "${SEPARATE_BAR}") | sed '/^$/d')
echo "${ls_header}"
if [ ${ls_display_num} -gt ${LESS_BORDER_NUM} ];then less_swich=1;fi
if [ ${less_swich} -eq 1 ];then
	ls_display_content=$(cat <(echo "${ls_header}") <(echo "${ls_display_content}"))
	LANG="ja_JP.UTF-8" echo "${ls_display_content}" | sed -r "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g" | sed -r "s/(^\([0-9]{1,6}\))/\x1b[38;5;2m\1\x1b[0m/g" | sed -r "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g" | less -R
else
	LANG="ja_JP.UTF-8" echo "${ls_display_content}" | sed -r "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g" | sed -r "s/(^\([0-9]{1,6}\))/\x1b[38;5;2m\1\x1b[0m/g" | sed -r "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g"
fi
exit 0