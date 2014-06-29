import json
from warnings import warn

import json
import re
import copy
import codecs
import sys

from parsingClasses import *

root="."
authors = root + "/files/ol_dump_authors_latest.txt"

class OLline(dict):
    #This is for processing an input line into a dictionary.
    def __init__(self,line):
        try:
            entry = json.loads(line.split("\t")[4])
            self.broken=0
        except:
            entry = dict()
            self.broken=1
        for key in entry.keys():
            self[key] = entry[key]
        try:
            self.etype = re.sub(".*/","",entry['type']['key'])
        except:
            pass


for line in open(authors):
    entry = OLline(line)
    output = dict()
    if entry.broken:
        
        continue
    for variable in ["name","personal_name"]:
        try:
            output[variable] = entry[variable]
        except KeyError:
            pass
    for datefield in ["birth_date","death_date"]:
        try:
            output[datefield] = date(entry[datefield]).extract_year()
        except KeyError:
            pass
    try:
        output['death_age'] = int(output['death_date']) - int(output['birth_date'])
    except TypeError:
        raise
        print "\n\n\n"
        print output
        print "\n\n\n"
    except KeyError:
        pass
    except ValueError:
        pass

    try:
        output['first_name'] = output['personal_name'].split(" ")[0]
    except:
        try:
            entry['first_name'] = output['name'].split(" ")[0]
        except:
            pass
    output['authors'] = entry['key']
    print json.dumps(output)


