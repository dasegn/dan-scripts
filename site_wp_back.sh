#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

set -u

MYSQLDUMP="$(which mysqldump)"
PATH_TO="/var/www/html/files"
PATH_FROM="/var/www/html/dnias"
DATE_NOW="$(date +"%Y-%m-%d_%H-%M-%S")"
WEB_GROUP_USER="www-data"

#MySQL Data Connection
SERVER="localhost"
DATABASE=""
USER=""
PASS=""

#Final Filenames
FILE_SQL=$DATABASE-$DATE_NOW.sql.gz
FILE_TAR=$DATABASE-$DATE_NOW.tar.gz

echo "Fecha: ${DATE_NOW}"
echo "Ruta destino: ${PATH_TO}"
echo "Ruta origen: ${PATH_FROM} \n"

#Generate MySQL Dump File
echo "Generando archivo SQL ${FILE_SQL}"
$MYSQLDUMP --add-drop-table -u $USER -p$PASS --opt $DATABASE | gzip -c > $PATH_TO/$FILE_SQL 

#Generate TAR.GZ Wordpress file
echo "Generando archivo TAR.GZ ${FILE_TAR}"
tar -zcf $PATH_TO/$FILE_TAR $PATH_FROM/* 

#Delete files with 2 hours age
echo "Eliminando archivos con más de cuatro horas en ${PATH_TO} \n"
find $PATH_TO -mmin +240 -type f -delete
