#!/bin/sh
hadoop fs -put /examples/text/shakespeare.txt /
hadoop fs -rm -r /longestline
hadoop jar target/longestline-1.0.0.jar com.roi.hadoop.longestline.Main /shakespeare.txt /longestline hungry fair hark lovely
hadoop fs -cat /longestline/*
