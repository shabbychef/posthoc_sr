
######################
######################
# makefile generated 
# dude makefile 
# created by s.e.pav 
# $Id: Makefile 89 2006-01-26 20:59:08Z spav $
######################
######################

############### FLAGS ###############

# these don't work at times
# in that case set these by hand?

LATEX       := $(shell which latex)
BIBTEX      := $(shell which bibtex)
PDFLATEX    := $(shell which pdflatex)
MAKEINDEX   := $(shell which makeindex)
PAGER   		:= $(shell which less)
ASPELL  		:= $(shell which aspell)

RLIB         = /usr/lib64/R

TEXINPADD    = .:./Definitions:$(RLIB)/share/texmf/tex/latex

PRETEX       = TEXINPUTS=$(TEXINPADD):$$TEXINPUTS
PREBIB       = BSTINPUTS=$(TEXINPADD):$$BSTINPUTS \
               BIBINPUTS=$(TEXINPADD):$$BIBINPUTS 

PREIDX       = INDEXSTYLE=$(TEXINPADD):$$INDEXSTYLE

#undoes psfrag for pdf
UNPSFRAG		 = perl $(HOME)/sys/bin/unpsfrag.pl
#unroll commands
DETEXIFY		 = perl $(HOME)/sys/perl/detexify.pl

SCREEN_SIZE  = normal
#include	$(HOME)/sys/etc/.Makefile.local

#PROJECT      = $(notdir $(PWD))
PROJECT      = posthoc
TEX_SOURCE   = $(PROJECT).tex
BIB_SOURCE   = $(PROJECT).bib
DVI_TARGET   = $(PROJECT).dvi
PDF_TARGET   = $(PROJECT).pdf
BBLS         = $(PROJECT).bbl

#SAVE
# tracked projects
PROJECTS     = $(PROJECT) 
#UNSAVE
# add on dependencies (subchapters of this project)
R_DEPS 			 = 
TEX_EXTRAS   = SharpeR.sty common.bib 
# nonlocal dependencies
STY_FILES    = 

#aspell
ASPELL_FLAGS = 

ARXIV_VERSION  			 = v1
ARXIV_TAG 					 = $(PROJECT)_$(ARXIV_VERSION)

############## DEFAULT ##############

default : all

############## MARKERS ##############

.PHONY   : 
.SUFFIXES: .tex .bib .dvi .ps .pdf .eps
.PRECIOUS: %.pdf 

############ BUILD RULES ############

.PHONY   : help 

# this will have to change b/c of inclusion file names...
help:  ## generate this help message
	@grep -h -P '^(([^\s]+\s+)*([^\s]+))\s*:.*?##\s*.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY   : all

# an easy target
all : $(PROJECT).pdf  ## build the document by knitting source code

.PHONY   : doc

doc : $(PROJECT).pdf  ## build the document by knitting source code

%.tex : %.Rnw $(R_DEPS)
		Rscript -e 'require(knitr);knit("$<")'
		@-perl -pi -e 's/(syn|ft)=(Rnw|rnoweb)/$$1=tex/g;' $@

%.R : %.Rnw
		Rscript -e 'require(knitr);knit("$<",tangle=TRUE)'
		@-perl -pi -e 's/(syn|ft)=(Rnw|rnoweb)/$$1=R/g;' $@

%.pdf : %.tex
	latexmk -f -bibtex -pdf -pdflatex="$(PDFLATEX)" -use-make $<

# tex extras
%.bbl : %.bib
	$(PREBIB) $(BIBTEX) $*

%.bbl : %.aux
	$(PREBIB) $(BIBTEX) $*

%.ind : %.idx
	$(PREIDX) $(MAKEINDEX) $*

# check a document
%.chk : %.dup %.spell

# check spelling
%.spell : %.tex
	$(ASPELL) $(ASPELL_FLAGS) --dont-tex-check-comments -t -l < $< | sort | uniq | $(PAGER)

# check duplicate words
%.dup : %.tex
	perl -an -F/\\s+/ -e 'BEGIN { $$last = q[]; $$line = 0; $$prevline = q[];}\
	$$line++;$$first = 1;\
	foreach $$word (@F) {\
	if ($$word eq $$last) {\
	if ($$first) { print qq[duplicate $$word, lines ],($$line-1),qq[-$$line:\n$$prevline$$_]; }\
	else { print qq[duplicate $$word, line $$line:\n$$_]; } }\
	$$last = $$word; $$first = 0; } \
	$$prevline = $$_;' < $< | $(PAGER)

############# CLEAN UP ##############

# clean up
%.clean : 
		-rm -f $*.aux $*.log $*.dvi $*.bbl $*.blg $*.toc $*.ilg $*.ind
		-rm -f $*.out $*.idx $*.lot $*.lof $*.brf $*.nav $*.snm $*.fls 

%.realclean : %.clean
		-rm -f $*.ps $*.pdf
		-rm -f $*.fdb_latexmk
		-rm -f $*-[0-9][0-9][0-9]*.eps $*-[0-9][0-9][0-9]*.pdf

############### RULES ###############


release.tex: $(PROJECT).tex
	perl -pe 's{figure/}{};' < $< > $@

release : release.tex  ## make a form of tex to upload to arxiv
	mv release.tex $(PROJECT).tex
	@-echo "upload to arxiv"

# check it

spell: $(PROJECT).spell 

# clean up
clean: $(patsubst %,%.clean,$(PROJECTS))
	latexmk -c


realclean: $(patsubst %,%.realclean,$(PROJECTS))
		-rm -f Rplots.pdf

cleancache: 
		echo "killing knitr cache! ack!"
		-rm -rf cache

superclean: realclean cleancache

.tags :
	nice -n 18 ctags -f .tmp_tags --recurse --language-force=R --fields=+i `find . -regextype posix-egrep -regex '.*.R(nw)?'`;
	mv .tmp_tags $@

# github tags

tag : ## advice on github tagging
	@-echo "git tag -a $(ARXIV_TAG) -m 'release to arxiv $(ARXIV_TAG)'"
	@-echo "git push --tags"

really_tag : ## actually github tag 
	git tag -a $(ARXIV_TAG) -m 'release to arxiv $(ARXIV_TAG)'
	git push --tags

untag : ## advice on github untagging
	@-echo "git tag --delete $(ARXIV_TAG)"
	@-echo "git push origin :$(ARXIV_TAG)"


#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=149:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:
