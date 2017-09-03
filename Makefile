# Makefile for org-person

VERSION="$(shell sed -nre '/^;; Version:/ { s/^;; Version:[ \t]+//; p }' org-person.el)"
DISTFILE = org-person-$(VERSION).zip

# EMACS value may be overridden
EMACS?=emacs
EMACS_MAJOR_VERSION=$(shell $(EMACS) -batch -eval '(princ emacs-major-version)')
ORG_PERSON_ELC=org-person.$(EMACS_MAJOR_VERSION).elc

EMACS_BATCH=$(EMACS) --batch -Q

default:
	@echo version is $(VERSION)

%.$(EMACS_MAJOR_VERSION).elc: %.elc
	mv $< $@

%.elc: %.el
	$(EMACS_BATCH) -f batch-byte-compile $<

compile: $(ORG_PERSON_ELC)

.PHONY: test-compiled-nocask test-uncompiled-nocask test-compiled test-uncompiled
# check both regular and compiled versions
test-nocask: test-compiled-nocask test-uncompiled-nocask

test: test-compiled test-uncompiled

test-compiled-nocask: $(ORG_PERSON_ELC)
	$(EMACS) -batch -l $(ORG_PERSON_ELC) -l buttercup -f buttercup-run-discover

test-uncompiled-nocask:
	$(EMACS) -batch -l org-person.el -l buttercup -f buttercup-run-discover

test-compiled: $(ORG_PERSON_ELC)
	EMACS=$(EMACS) cask exec buttercup -l $(ORG_PERSON_ELC)

test-uncompiled:
	EMACS=$(EMACS) cask exec buttercup -l org-person.el
