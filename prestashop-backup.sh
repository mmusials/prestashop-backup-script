#!/bin/bash

PATH_TO_SHOP=$1
CURRENT_DIR=$(pwd)

SHOP_PATH="$CURRENT_DIR/$PATH_TO_SHOP"
SHOP_SETTING_FILE="$SHOP_PATH/config/settings.inc.php"

echo $SHOP_PATH
if [ -z $1 ] || [ ! -d $SHOP_PATH ] || [ ! -f $SHOP_SETTING_FILE ] 
	then 
	echo "folder nie istnieje"	
	exit 1;
fi

DB_NAME=`grep -oP "(?<=_DB_NAME_',\s')[^']*" $SHOP_SETTING_FILE`
DB_USER=`grep -oP "(?<=_DB_USER_',\s')[^']*" $SHOP_SETTING_FILE`
DB_PASSWD=`grep -oP "(?<=_DB_PASSWD_',\s')[^']*" $SHOP_SETTING_FILE`

BACKUP_FOLDER_NAME="BACKUPS/BACKUP_`date +%Y-%m-%d`"

if [ ! -d $BACKUP_FOLDER_NAME ]
then
mkdir -p $BACKUP_FOLDER_NAME;
fi

if [ ! -z DB_PASSWD ]
then
	PASS_PART=" -p$DB_PASSWD "
else
	PASS_PART=""
fi
SQL_BACKUP_NAME="sqldump-`date +%H-%M`.sql" 
FTP_BACKUP_NAME="ftp-`date +%H-%M`.tar.gz"
#DUMP="`mysqldump -u $DB_USER $PASS_PART $DB_NAME > $BACKUP_FOLDER_NAME/$SQL_BACKUP_NAME`"
#$DUMP
`gzip -c $BACKUP_FOLDER_NAME/$SQL_BACKUP_NAME > $BACKUP_FOLDER_NAME/$SQL_BACKUP_NAME.gz`
`tar --exclude='./img/p/*' --exclude='./cache/*' --exclude='./blog/*' -zcvf $BACKUP_FOLDER_NAME/$FTP_BACKUP_NAME -C $SHOP_PATH .`
#echo "`tar -r $BACKUP_FOLDER_NAME/$FTP_BACKUP_NAME $SHOP_PATH -x "$SHOP_PATH/img/tmp/*" "$SHOP_PATH/img/p/*" "$SHOP_PATH/cache/*"`"
