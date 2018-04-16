#! /bin/sh
if [ ! -d "/data/hdfs/name" ]; then
  /scripts/format-namenode.sh
  /scripts/init-schema-mysql.sh
fi
