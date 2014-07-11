

### STUFF TO DO WITH THE BOOKWORM--run second

bookworm: OL OL/files/metadata/field_descriptions.json OL/files/metadata/jsoncatalog.txt input.txt.gz
	cd OL; make files/targets/encoded textStream="gunzip -c ../input.txt.gz";
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

files/texts/raw//compressed.lzo:

files/texts/raw/%/compressed.lzo: files/texts/raw/%
	find $< -name "*.txt" | parallel -P 4 python OLprinter.py | lzop -c > $@

#Compressed lzo files for each two-letter prefix gives an easier way to read things in.
compressions: $(addsuffix /compressed.lzo, $(shell find files/texts/raw -maxdepth 1 -mindepth 1 -type d  | sort | tr " " "\n" | egrep "files/texts/raw/([A-Za-z0-9_-]){2}"))
	touch compressions

#### STUFF TO DO WITH METADATA--run first.


prefiles: files/ol_dump_editions_latest.txt files/ol_dump_works_latest.txt files/ol_dump_authors_latest.txt
	mkdir -p files
	touch prefiles

downloads: prefiles files/jsoncatalog.txt
	mkdir -p files/downloads
	python OL_download.py
	touch downloads

$(root)/metadata/catalog.txt: files/jsoncatalog.txt
	mkdir -p $(root)/files/metadata
	ln -s ../../../files/jsoncatalog.txt $@

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


