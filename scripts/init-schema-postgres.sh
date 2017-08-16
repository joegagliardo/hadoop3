#! /bin/sh
rm /etc/bootstrap.sh
ln -s /conf/bootstrap-postgres.sh /etc/bootstrap.sh 
chown root:root /etc/bootstrap.sh && \
chmod 700 /etc/bootstrap.sh && \
cp /usr/local/hive/conf/hive-site-postgres.xml /usr/local/hive/conf/hive-site.xml
/scripts/start-postgres.sh
sleep 5
sudo -u postgres psql -f /scripts/hiveuser-postgres.sql
schematool -dbType postgres -initSchema
