#!/bin/bash
less_swich=0
#display_usecase=$(cat <(echo -e "-> restore ex)\tdifbk rs {merge_list_full_path} {target_full_path} (grep path)") <(echo -e "-> validat merge list / clean ex)\tdifbk clean -v / -dddd {save to-^number} ") <(echo -e "-> edit desk ex)\tbkno {^merge_list_path}(include day_dir_path)") <(echo -e "-> etc ex)\tless {^path}, zdiff {^path} {^path}, bkep {keyowrd} {^path} (range(defo 2))"))
rga_after_num=1
# echo "GENERAL_OPTION: ${GENERAL_OPTION}"
IFS=$'\t'
E_OPTION=($(echo "${GENERAL_OPTION}" | rga -o "\-e"))
IFS=$' \n'
# echo "${E_OPTION[@]}"
# display val setting
case "${E_OPTION}" in 
	"-e") lrs_janre="${DIFBK_EVRYTIME_DISPLAY}";;
	*) lrs_janre="${DIFBK_DAILY_DISPLAY}";;
esac
# echo lrs_janre ${lrs_janre}

# produce rga command
dRGA_OPTION=$(echo ${dRGA_OPTION} | sed -re 's/-d([a-z]) /\ -\1\ /g')
desk_rga_cmd=$(make_desk_rga_comd "${rga_after_num}")
desk_rga_v_cmd=$(make_desk_rga_v_comd "${rga_after_num}")
if [ "${lrs_janre}" == "${DIFBK_DAILY_DISPLAY}" ];then
	LANG="ja_JP.UTF-8" fd . "${BUCK_UP_DIR_PATH}" -d 6 -t f | rga "/${BUCK_UP_DIR_NAME}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}" | sort -r | sed -r "s/^(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})/\2\t\1/" | uniq -f 1  | sed -re "s/^(\/[0-9]{4}\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}\/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME})\t(${SED_BUCK_UP_DIR_PATH}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2})/\2\1/"  -e 's/'${SED_TARGET_PAR_DIR_PATH}'/../' | nl -n ln | sed -r "s/^([0-9]{1,20})\ *\t(.*)/desk_path=\$(fd -d 2 -t f ${BUCKUP_DESC_FILE_NAME} \$(echo \"\2\" | sed 's\/[0-9]\\\{4\\\}\\\\\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*\/\/'))\; [ -n \"\${desk_path}\" ] \&\& cat \${desk_path} | sed 's\/^\/\[\1\]\t:desk: \/';echo \"\n\";echo \"\[\1\]\t\2\"/e" 2>/dev/null | sed -e '/^$/d' -re "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g"  -re "s/(^\([0-9]{1,6}\))/\x1b[1;38;5;2m\1\x1b[0m/g" -re "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g" | less -XR

elif [ "${lrs_janre}" == "${DIFBK_EVRYTIME_DISPLAY}" ];then
	lrs_con=$(fd -d 6 -t f ${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}  "${BUCK_UP_DIR_PATH}" | rga "^${BUCK_UP_DIR_PATH}/[0-9]{4}/[0-9]{2}/[0-9]{2}/[0-9]{4}/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}/${BUCKUP_MERGE_CONTENSTS_LIST_FILE_NAME}${DFBK_GGIP_EXETEND}$" | sort -r | sed 's/'${SED_TARGET_PAR_DIR_PATH}'/../'  | nl -n ln | sed -re "s/^([0-9]{1,20})\ *\t(.*)/desk_path=\$(echo \"\2\" | sed 's\/${BUCKUP_MERGE_CONTENSTS_LIST_DIR_NAME}.*\/${BUCKUP_DESC_FILE_NAME}\/')\; [ -e \"\${desk_path}\" ] \&\& cat \"\${desk_path}\" | sed 's\/^\/\[\1\]\t:desk: \/';echo \"\n\";echo \"\[\1\]\t\2\"/e" | sed -e '/^$/d' -re "s/(^\[[0-9]{1,6}\])/\x1b[38;5;2m\1\x1b[0m/g" -re "s/(^\([0-9]{1,6}\))/\x1b[1;38;5;2m\1\x1b[0m/g" -re "s/\t((:desk:\ .*))/\t\x1b[38;5;20m\1\x1b[0m/g") 
	LANG="ja_JP.UTF-8" eval "echo \"\${lrs_con}\" ${desk_rga_cmd} ${desk_rga_v_cmd}" | sed '/^--$/d'  | less -XR
fi
