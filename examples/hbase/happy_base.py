# hbase thrift start -threadpool

import happybase
connection = happybase.Connection('bigdata')
print(connection.tables())

blogposts = connection.table('blogposts')
row = blogposts.row(b'post1')
print(row[b'post:title'])

from collections import OrderedDict
rows = OrderedDict(blogposts.rows([b'post1', b'post2']))
print (rows)

