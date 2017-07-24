CREATE EXTERNAL TABLE blogposts(key string, author string, body string, head string, title string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key, post:author, post:body, post:head, post:title")
TBLPROPERTIES ("hbase.table.name" = "blogposts", 
"hbase.mapred.output.outputtable" = "blogposts");
