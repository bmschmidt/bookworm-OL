#! /usr/bin/python
import sys
from parsingClasses import *

files = sys.argv[1:]

#Some regular expressions that are us

def dropNewlines(text):
    return re.sub(r"[\n\r\t]"," ",text)

def dropGooglePrelude(text):
    return re.sub(r"^.{1000,8000}: ?/ ?/ ?book ?s ?\. ?[qg]oo[qg][liI]e ?\. ?co.","",text)



def removeIAattribution(text):
    return re.sub(r"^.{0,50}Digitized.{5,1000}(h|li)ttp\S+","",text)

def closeHyphens(text):
    return re.sub(r"- *\n([\n ])*","",text)

def printout(mine):
    text = open("files/texts/raw/" + mine.fileLocation()).read()
    text = closeHyphens(text)
    text = dropNewlines(text)
    text = removeIAattribution(text)
    text = dropGooglePrelude(text)
    if text[:5] == "<html" or text[:5] == "<!DOC":
        raise TypeError("it's HTML")
    return text

for file in files:
    try:
        file = ocaid(file)
        text = printout(file)
        print file.string + "\t" + text
    except TypeError:
        pass
    except IOError:
        pass


