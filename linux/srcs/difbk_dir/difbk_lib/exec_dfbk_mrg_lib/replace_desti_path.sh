#!/bin/bash


replace_desti_path(){
	cat "/dev/stdin"  | sed -r "s/^(\/${BUCK_UP_DIR_NAME}\/[0-9]{4}\/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\/${BACKUP_CREATE_DIR_NAME})\/${TARGET_DIR_NAME}/\1\/${1}/" | sed "s/\/\//\//g" | sed "s/^\/${BUCK_UP_DIR_NAME}/\/${2}/" | sed "s/\/\//\//g"
}

