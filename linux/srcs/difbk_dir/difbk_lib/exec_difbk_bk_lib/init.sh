#!/bin/bash

init(){
	if [ ! -e "${DFBK_LABEL_DIR_PATH}" ];then
		mkdir -p "${DFBK_LABEL_DIR_PATH}"
	fi
	if [ -e "${DFBK_CHECK_SUM_CULC_DIR_PATH}" ];then 
		rm -rf "${DFBK_CHECK_SUM_CULC_DIR_PATH}"
	fi
	if [ -e ${BUCKUP_DESC_TEMP_FILE_PATH} ];then 
		rm ${BUCKUP_DESC_TEMP_FILE_PATH}; 
	fi
	if [ ! -e ${DFBK_IGNORE_FILE_PATH} ];then 
		touch ${DFBK_IGNORE_FILE_PATH};
	fi
	mkdir -p "${DFBK_CHECK_SUM_CULC_DIR_PATH}" &
	rm -rf "${DFBK_CHECK_SUM_OUTPUT_FILE_PATH}" \
			"${DFBK_CHECK_SUM_OUTPUT_FILE_RCEIVE_PATH}" &
	[ ! -e "${DFBK_LABEL_DIR_PATH}" ] \
		&& mkdir -p "${DFBK_LABEL_DIR_PATH}"
	touch "${DFBK_LABEL_FILE_PATH}" &
}