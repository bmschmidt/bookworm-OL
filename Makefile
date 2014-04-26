

### STUFF TO DO WITH THE BOOKWORM--run second

Presidio:
	git clone git@github.com:bmschmidt/Presidio


Presidio/files/texts/raw:
	mkdir -p Presidio/files/texts
	ln -s ../../../files/texts/raw/ $@


Presidio/files/metadata/jsoncatalog.txt:
	mkdir -p Presidio/files/metadata
	ln -s ../../../files/jsoncatalog.txt $@

Presidio/files/metadata/field_descriptions.json:
	ln -s ../../../files/descriptions.txt $@

#### STUFF TO DO WITH METADATA--run first.

preFiles: files/ol_dump_editions_latest.txt files/ol_dump_editions_latest.txt files/ol_dump_authors_latest.txt

downloads: files/downloads
	mkdir -p files/downloads
	python OL_download.py
	touch downloads

files:
	mkdir -p files
	mkdir -p files/downloads

$(files)/metadata/field_descriptions.json:
	mv field_descriptions.json $(files)/metadata/field_descriptions.json

$(root)/metadata/catalog.txt: files/ol_dump_editions_latest.txt
	mkdir -p $(root)/files/metadata
	python OLparser.py

files/jsoncatalog.txt:
	python OLparser.py

files/ol_dump_works_latest.txt: files
	#grep ocaid to keep it smaller and more relevant
	curl -L http://openlibrary.org/data/ol_dump_works_latest.txt.gz | gunzip -c  > files/ol_dump_works_latest.txt

files/ol_dump_authors_latest.txt: files
	curl -L http://openlibrary.org/data/ol_dump_authors_latest.txt.gz | gunzip -c > files/ol_dump_authors_latest.txt

files/ol_dump_editions_latest.txt: files
	curl -L http://openlibrary.org/data/ol_dump_editions_latest.txt.gz | gunzip -c | grep ocaid > files/ol_dump_editions_latest.txt


