SHELL:=/bin/bash

BASE ?= $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))/../..
PARSER := $(BASE)/mediawiki-parser/target/release/mwtoast
DOCGEN := $(BASE)/serlo-docgen/target/release/mfnf_ex

ARTICLE_DIR := articles
SITEMAP ?= sitemap
PAGE ?= index.html

all: $(PAGE)

# utils
create_directory = mkdir -p '$(strip $1)'
dirsplit = $(subst /,$(space),$1)
unescape = $(shell jq 'import "scripts/lib" as lib; "$1" | lib::unescape_make | @sh' -n -r)

$(ARTICLE_DIR)/%.raw.json: $(ARTICLE_DIR)/%.md
	$(info parsing '$*'...)
	@$(PARSER) --json < $< > $@

$(ARTICLE_DIR)/%.json: $(ARTICLE_DIR)/%.raw.json
	$(info normalizing $(word 2,$(call dirsplit,$@)))
	@$(DOCGEN) default edtr ARTIKELNAME < $< > $@

$(ARTICLE_DIR)/%.md:
	@$(call create_directory,$(dir $@))
	$(eval UNESCAPED := $(call unescape,$(word 2,$(call dirsplit,$@))))
	$(info fetching source of $(UNESCAPED)...)
	@curl -sgsf -G 'https://de.wikibooks.org/w/index.php' \
		--data-urlencode action=raw \
		--data-urlencode title=$(UNESCAPED) \
		--data-urlencode oldid='$(notdir $*)' \
	> $@

$(SITEMAP):
	curl -sgsf -G 'https://de.wikibooks.org/w/index.php' \
		--data-urlencode action=raw \
		--data-urlencode title='Mathe_für_Nicht-Freaks:_Sitemap' \
	> $@

$(PAGE): $(SITEMAP)
	./get_all_states.sh $@
