#!/bin/sh
hadoop fs -copyFromLocal /home/student/roi_hadoop/datasets/shakespeare.txt /shakespeare.txt
hadoop fs -rm -r /javaoutput
hadoop jar /home/student/roi_hadoop/solutions/longestline/target/longestline-1.0.0.jar com.roi.hadoop.longestline.Main /shakespeare.txt /javaoutput hungry fair hark lovely
hadoop fs -cat /javaoutput/*
