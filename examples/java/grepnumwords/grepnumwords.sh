#!/bin/sh
hadoop fs -put /examples/text/shakespeare.txt /
hadoop fs -rm -r /grepnumwords
hadoop jar target/grepnumwords-1.0.0.jar com.roi.hadoop.grepnumwords.Main /shakespeare.txt /grepnumwords hungry fair king queen maiden $
hadoop fs -cat /grepnumwords/*



