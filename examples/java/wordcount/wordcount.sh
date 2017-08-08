#!/bin/sh

hadoop fs -put /examples/text/shakespeare.txt /
hadoop fs -rm -r /wordcount
hadoop jar target/wordcount-1.0.0.jar com.roi.hadoop.wordcount.Main /shakespeare.txt /wordcount
hadoop fs -cat /wordcount/*
