#! /bin/sh
hadoop fs -put /examples/text/shakespeare.txt /
hadoop fs -rm -r /grep_spark1
spark-submit spark1.py
hadoop fs -ls /grep_spark1
hadoop fs -cat /grep_spark1/*
