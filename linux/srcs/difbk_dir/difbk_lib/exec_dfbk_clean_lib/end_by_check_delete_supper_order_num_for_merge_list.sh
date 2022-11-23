#!/bin/bash


end_by_check_delete_supper_order_num_for_merge_list(){
	if [ -z "${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST}" ];then 
		echo "valid parater not found (${BUCKUP_CLEAN_ARGS_NAME} DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST:clean, ${RECENT_MERGE_LIST_VALIDATE_ARGS_NAME}: mergelist validation)"
		exit 0 ;
	fi
	if ! expr ${DELETE_SUPPER_ORDER_NUM_FOR_MERGE_LIST} + 1 2>/dev/null ;then 
		echo "no second para nomeric (base regester date)"
		exit 0	
	fi
}