#! /bin/sh
ln -s /conf/bootstrap-mysql.sh /etc/bootstrap.sh 
chown root:root /etc/bootstrap.sh && \
chmod 700 /etc/bootstrap.sh && \
cp /usr/local/hive/conf/hive-site-mysql.xml /usr/local/hive/conf/hive-site.xml
/scripts/start-mysql.sh
sleep 5
mysql < /scripts/hiveuser-mysql.sql
schematool -dbType mysql -initSchema
