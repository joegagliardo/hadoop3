#! /bin/sh
kill -9 $(cat /scripts/cassandra_processid)
rm scripts/cassandra_processid
