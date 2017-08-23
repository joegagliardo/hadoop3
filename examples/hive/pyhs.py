#! /usr/bin/python

import pyhs2

with pyhs2.connect(host='localhost',
                   port=10000,
                   authMechanism="PLAIN",
                   user='root',
                   password='',
                   database='default') as conn:
    with conn.cursor() as cur:
        #Show databases
        print cur.getDatabases()

        #Execute query
        cur.execute("select * from regions")

        #Return column info from query
        print cur.getSchema()

        #Fetch table results
        for i in cur.fetch():
            print i

