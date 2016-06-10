#
# Makefile to convert DocBook CLM Users-Guide into html and/or pdf
# (rtf, txt, ps, tex, man, dvi, and texi are also valid docbook formats)
#
VPATH := ../../tools ../../tools/cprnc . .. ../../bld ../../tools/shared/ncl_scripts \
	../../tools/clm4_5/mksurfdata_map ../../test/tools ../../tools/shared/mkmapdata ../../bld/namelist_files \
	../../bld/config_files ../../tools ../../../../../scripts/ccsm_utils/Tools ../../test/system \
        ../../../../../scripts/ccsm_utils/Tools/lnd/clm/PTCLM/ ../../src/clm4_5/main \
        ../../src/clm4_0/main

PDFUG       := clm_ug.pdf
HTMLUG      := book1.html
DOCBKUG     := clm_ug.xml
CFGLOG      := config_help
TOOLOG      := tools_readme
CPRLOG      := cprnc_readme
TOOLOG      := tools_readme
CO2TXT      := addco2_user_nl_datm
CO2STR      := datm.streams.txt.co2tseries
BNMLOG      := buildnml_help
RESLOG      := buildnml_resolutions
USCLOG      := buildnml_usecases
QCKLOG      := quickstart_guide
COPLOG      := filecopies
MKSLOG      := mksurfdata.pl
PTCLOG      := ptclm_help
PTCLST      := ptclm_list
MKGLOG      := mknoocnmap.pl
MKMLOG      := mkmapdata.sh
TDRLOG      := test_driver.sh
DATLOG      := build_date
NMLDFTBL40  := namelist_definition_table_40
NMLDLTBL40  := namelist_defaults_clm_table_40
NMLDFTBL45  := namelist_definition_table_45
NMLDLTBL45  := namelist_defaults_clm_table_45
HSFLDTBL40  := history_fields_table_40
HSFLDTBL45  := history_fields_table_45
CFGDFTBL    := config_definition_table
COMPLIST    := compsets_list_ofIcases.xml
MODNLIDX    := index.html
SOURCES     := $(DOCBKUG) $(COMPLIST) $(CFGLOG).xml $(PTCLOG).xml $(BNMLOG).xml \
             $(RESLOG).xml $(USCLOG).xml $(QCKLOG).xml $(COPLOG).xml $(PTCLST).xml \
             preface.xml custom.xml special_cases.xml $(CO2STR).xml \
             tools.xml adding_files.xml single_point.xml testing.xml \
             appendix.xml trouble_shooting.xml $(CO2STR).xml $(CO2TXT).xml ptclm.xml \
             $(MKSLOG).xml $(MKGLOG).xml $(MKMLOG).xml $(TDRLOG).xml $(DATLOG).xml $(CPRLOG).xml $(TOOLOG).xml \
	     $(NMLDFTBL40).xml $(NMLDLTBL40).xml $(CFGDFTBL).xml $(HSFLDTBL40).xml \
	     $(NMLDFTBL45).xml $(NMLDLTBL45).xml                 $(HSFLDTBL45).xml modelnl/$(MODNLIDX)
SPCHKFILS   := preface.spck custom.spck special_cases.spck \
               tools.spck adding_files.spck single_point.spck testing.spck \
               appendix.spck trouble_shooting.spck ptclm.spck

CONVAMP    := sed 's/\&/\&amp;/g'
CONVSIGNS  := sed 's/>/\&gt;/g' | sed 's/</\&lt;/g'
SKIPTAGS   := \
       --add-sgml-skip=author \
       --add-sgml-skip=command \
       --add-sgml-skip=email \
       --add-sgml-skip=envar \
       --add-sgml-skip=filename \
       --add-sgml-skip=firstname \
       --add-sgml-skip=guimenu \
       --add-sgml-skip=keycap \
       --add-sgml-skip=literal \
       --add-sgml-skip=option \
       --add-sgml-skip=remark \
       --add-sgml-skip=screen \
       --add-sgml-skip=surname \
       --add-sgml-skip=systemitem \
       --add-sgml-skip=ulink \
       --add-sgml-skip=varname \
       --add-sgml-skip=xref \
       --add-sgml-skip=releaseinfo \
       --add-sgml-skip=acronym \
       --add-sgml-skip=envar \
       --run-together --run-together-limit=4

all: spellcheck $(HTMLUG) $(PDFUG) modelnl/$(MODNLIDX)

.SUFFIXES:
.SUFFIXES: .xml .pdf .html .tlog .user_nl .diff .xhtml .xsl .spck

RM := /bin/rm

$(CFGLOG).xml: $(CFGLOG).tlog
$(PTCLOG).xml: $(PTCLOG).tlog
$(PTCLST).xml: $(PTCLST).tlog
$(BNMLOG).xml: $(BNMLOG).tlog
$(RESLOG).xml: $(RESLOG).tlog
$(USCLOG).xml: $(USCLOG).tlog
$(QCKLOG).xml: $(QCKLOG).tlog
$(COPLOG).xml: $(COPLOG).tlog
$(MKSLOG).xml: $(MKSLOG).tlog
$(MKGLOG).xml: $(MKGLOG).tlog
$(MKMLOG).xml: $(MKMLOG).tlog
$(CPRLOG).xml: $(CPRLOG).tlog
$(TOOLOG).xml: $(TOOLOG).tlog
$(DATLOG).xml: $(DATLOG).tlog
$(CO2STR).xml: $(CO2STR).tlog

spellcheck:  $(SPCHKFILS)
	touch book1.spck

$(NMLDFTBL40).xhtml: namelist_definition_clm4_0.xml namelist_definition.xsl
	xsltproc ../../bld/namelist_files/namelist_definition.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

$(NMLDLTBL40).xhtml: namelist_defaults_clm4_0.xml namelist_defaults.xsl
	xsltproc ../../bld/namelist_files/namelist_defaults.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

$(NMLDFTBL45).xhtml: namelist_definition_clm4_5.xml namelist_definition.xsl
	xsltproc ../../bld/namelist_files/namelist_definition.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

$(NMLDLTBL45).xhtml: namelist_defaults_clm4_5.xml namelist_defaults.xsl
	xsltproc ../../bld/namelist_files/namelist_defaults.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

$(CFGDFTBL).xhtml: config_definition.xml config_definition.xsl
	xsltproc ../../bld/config_files/config_definition.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

history_fields_clm4_0.xml: findHistFields.pl
	cd ../../src/clm4_0/main; ./findHistFields.pl >& tmpFile.txt
	$(RM) tmpFile.txt

history_fields_clm4_5.xml: findHistFields.pl
	cd ../../src/clm4_5/main; ./findHistFields.pl >& tmpFile.txt
	$(RM) tmpFile.txt

$(HSFLDTBL40).xhtml: history_fields_clm4_0.xml history_fields.xsl
	xsltproc ../../bld/namelist_files/history_fields.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

$(HSFLDTBL45).xhtml: history_fields_clm4_5.xml history_fields.xsl
	xsltproc ../../bld/namelist_files/history_fields.xsl $< > tmpFile.txt
	./addxhtmlhead.pl tmpFile.txt > $@
	$(RM) tmpFile.txt

.xhtml.xml:
	xsltproc stylesheethtml2docbook.xsl $< > $@

.xml.spck:
	aspell --mode=sgml --encoding=utf-8 $(SKIPTAGS) --personal=./aspell.en.pws -c $<
	touch $@

.tlog.xml:
	$(CONVAMP) $< | $(CONVSIGNS) > tempFile.txt
	./limitLineLen.pl tempFile.txt  > $@
	$(RM) tempFile.txt

.diff.xml:
	$(CONVAMP) $< | $(CONVSIGNS) > $@

.user_nl.xml:
	$(CONVAMP) $< | $(CONVSIGNS) > $@

debug:
	@echo "SOURCES:      $(SOURCES)"
	@echo "SP-CHK FILES: $(SPCHKFILS)"
	@echo "CONVAMP:      $(CONVAMP)"
	@echo "CONVSIGNS:    $(CONVSIGNS)"

$(COMPLIST): 
	./get_Icaselist.pl > $@

$(HTMLUG): $(SOURCES)
	docbook2html --dsl clm_stylesheet.dsl#html $<

$(PDFUG): $(SOURCES)
	docbook2pdf --dsl clm_stylesheet.dsl#print $<

modelnl/$(MODNLIDX): 
	cd modelnl && $(MAKE) $(MAKEFLAGS)

$(BNMLOG).tlog: build-namelist
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../bld/build-namelist -help >& $@

$(DATLOG).tlog:
	@echo "Get current build date"
	date  +%b-%d-%Y >& $@

$(RESLOG).tlog: build-namelist
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../bld/build-namelist -res list >& $@

$(USCLOG).tlog: build-namelist
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../bld/build-namelist -use_case list >& $@

$(CFGLOG).tlog: configure
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../bld/configure -help >& $@

$(PTCLOG).tlog: PTCLM.py
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../../../../scripts/ccsm_utils/Tools/lnd/clm/PTCLM/PTCLM.py --help >& $@

$(PTCLST).tlog: PTCLM.py
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	cd ../../../../../scripts/ccsm_utils/Tools/lnd/clm/PTCLM; \
	PTCLM.py --list >& $(CURDIR)/$@

$(MKSLOG).tlog: mksurfdata.pl
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../tools/clm4_5/mksurfdata_map/mksurfdata.pl -help >& $@

$(MKGLOG).tlog: mknoocnmap.pl
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../tools/shared/mkmapdata/mknoocnmap.pl -help >& $@

$(MKMLOG).tlog: mkmapdata.sh
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../tools/shared/mkmapdata/mkmapdata.sh --help >& $@

$(TDRLOG).tlog: test_driver.sh
	@echo "The following line will fail in the make as it calls die -- but that is expected"
	@echo "Check that the output $@ is good and redo your make"
	../../test/tools/test_driver.sh -help >& $@

$(QCKLOG).tlog: Quickstart.GUIDE
	cp $<  $@

$(COPLOG).tlog: README.filecopies
	cp $<  $@

$(CPRLOG).tlog: README
	cp $<  $@

$(CO2STR).tlog: datm.streams.txt.co2tseries
	cp $<  $@

$(TOOLOG).tlog: README
	cp $<  $@

clean:
	$(RM) -f $(HTMLUG) $(PDFUG) *.tlog $(DATLOG).xml *.xhtml *.tex *.spck

realclean: clean
	$(RM) -f f*.html c*.html x*.html a*.html i*.html $(COMPLIST) $(CFGLOG).xml \
	$(BNMLOG).xml \
	$(RESLOG).xml $(USCLOG).xml $(USRLOG).xml $(QCKLOG).xml \
	*.tlog $(MKSLOG).xml $(MKGLOG).xml $(MKMLOG).xml $(TDRLOG).xml $(DATLOG).xml \
	$(NMLDFTBL).xml $(NMLDLTBL).xml $(CFGDFTBL).xml $(CPRLOG).xml $(TOOLOG).xml \
	$(COPLOG).xml $(CO2STR).xml

