#/bin/bash

find files/texts/raw -name "*.txt" | perl -ne 'print if rand() < .01' | parallel -n 100 python OLprinter.py | head -1000
#find files/texts/raw -name "*.txt" | parallel -n 100 python OLprinter.py
