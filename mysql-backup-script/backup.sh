#! /bin/bash

TIME=$(date +%Y-%M-%d)
BACKUP_DIR=/backup/$TIME
MYSQL_USER=backup
MYSQL_PASSWORD=password
MSG=/tmp/mysqlbackup.messages

mkdir -p "$BACKUP_DIR/mysql"

databases=`mysql —user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`

for db in $databases; do
	mysqldump —force —opt —user=$MYSQL_USER -p$MYSQL_PASSWORD —databases $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done

if [ "$?" -eq 0 ]
then
    rsync -v $BACKUP_DIR/mysql/$db.gz backup@backup.server.com:~/`" 
else
    echo "Mysqldump encountered a problem" >> $MSG
fi
exit 0
