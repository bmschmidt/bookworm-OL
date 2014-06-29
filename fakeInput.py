#!/usr/bin/python

import json

output = "input.txt"

for line in open("files/jsoncatalog.txt"):
    doc = json.loads(line)
    try:
        printable = doc['filename'] + "\t" + doc['title']
        print (printable.encode("utf-8"))
    except KeyError:
        pass
    
