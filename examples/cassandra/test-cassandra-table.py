#! /usr/bin/python
from cassandra.cluster import Cluster
cluster = Cluster()
session = cluster.connect('joey')
rows = session.execute('SELECT id, name FROM names')
print list(rows)
