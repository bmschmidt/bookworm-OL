#/bin/bash

find files/texts/raw -name "*.txt" | parallel -n 100 python OLprinter.py
