

### STUFF TO DO WITH THE BOOKWORM--run second

bookworm: OL OL/files/texts/input.txt OL/files/metadata/field_descriptions.json OL/files/metadata/jsoncatalog.txt OL/files/texts/input.txt
	cd OL; make;
	touch $@


OL:
	git clone git@github.com:bmschmidt/Presidio $@


OL/files/texts/raw: OL
	mkdir -p OL/files/texts
	ln -sf ../../../files/texts/raw/ $@


OL/files/metadata/jsoncatalog.txt:
	mkdir -p OL/files/metadata
	ln -sf ../../../files/jsoncatalog.txt $@

OL/files/metadata/field_descriptions.json:
	mkdir -p OL/files/metadata
	ln -sf ../../../field_descriptions.json $@

input.txt.gz:
	find files/texts/raw -name "*.txt" | xargs -P 4 python OLprinter.py | gzip > $@ &

OL/files/texts/input.txt:
	mkdir -p OL/files/texts
	ln -s ../../../input.txt $@


#### STUFF TO DO WITH METADATA--run first.


prefiles: files/ol_dump_editions_latest.txt files/ol_dump_works_latest.txt files/ol_dump_authors_latest.txt
	touch prefiles

downloads: files/downloads prefiles files/jsoncatalog.txt
	mkdir -p files/downloads
	python OL_download.py
	touch downloads

files: 
	mkdir -p files

files/downloads: files
	mkdir -p files/downloads

$(files)/metadata/field_descriptions.json:
	mv field_descriptions.json $(files)/metadata/field_descriptions.json

$(root)/metadata/catalog.txt: files/ol_dump_editions_latest.txt
	mkdir -p $(root)/files/metadata
	python OLparser.py

files/jsoncatalog.txt: prefiles
	python OLparser.py

files/authorjson.txt: prefiles
	python authorParser.py > $@

files/ol_dump_works_latest.txt:
	#grep ocaid to keep it smaller and more relevant
	curl -L http://openlibrary.org/data/ol_dump_works_latest.txt.gz | gunzip -c  > $@

files/ol_dump_authors_latest.txt:
	curl -L http://openlibrary.org/data/ol_dump_authors_latest.txt.gz | gunzip -c > $@

files/ol_dump_editions_latest.txt:
#Only downloading those matching the string "ocaid", which should be the ones that are downloadable from archive.org.
	curl -L http://openlibrary.org/data/ol_dump_editions_latest.txt.gz | gunzip -c | grep ocaid > $@


