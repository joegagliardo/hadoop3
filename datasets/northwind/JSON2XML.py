import json
from dicttoxml import dicttoxml
from os import listdir
from os.path import isfile, join
mypath = '/home/Dev/bigdata-docker/newnorthwind2/J'
onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
print onlyfiles
onlyfiles = ['orderdetails.json', 'orders.json', 'products.json', 'regions.json', 'shippers.json', 'suppliers.json', 'territories.json', 'usstates.json']]
for file in onlyfiles:
    with open(mypath + '/' + file) as f:
        lines1 = f.readlines()
        print lines1
        lines1a = '[' + ','.join(lines1) + ']'
        print lines1a
        lines2 = json.loads(lines1a)
        print lines2
        lines3 = dicttoxml(lines2)
        print lines3
        with open(mypath + '/' + file + '.xml', 'w') as o:
            o.write(lines3)

