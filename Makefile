VERSION = $(shell cat "VERSION")
PREFIX = recycleme
BIN = @recycleme
ZIP = recycleme
FLAGS = -i include -w unquoted-string -w redefinition-wo-undef
VERSION_FILES = README.md mod.cpp

MAJOR = $(word 1, $(subst ., ,$(VERSION)))
MINOR = $(word 2, $(subst ., ,$(VERSION)))
PATCH = $(word 3, $(subst ., ,$(VERSION)))
BUILD = $(word 4, $(subst ., ,$(VERSION)))
VERSION_S = $(MAJOR).$(MINOR).$(PATCH)
GIT_HASH = $(shell git log -1 --pretty=format:"%H" | head -c 8)

ifeq ($(OS), Windows_NT)
	ARMAKE = ./tools/armake.exe # Downloaded via make.ps (rename armake_wXY.exe otherwise)
else
	ARMAKE = armake
endif

$(BIN)/addons/$(PREFIX)_%.pbo: addons/%
	@mkdir -p $(BIN)/addons
	@echo "  PBO  $@"
	@${ARMAKE} build ${FLAGS} -f -e "version=$(GIT_HASH)" $< $@

# Shortcut for building single addons (eg. "make <component>.pbo")
%.pbo:
	"$(MAKE)" $(MAKEFLAGS) $(patsubst %, $(BIN)/addons/$(PREFIX)_%, $@)

all: $(patsubst addons/%, $(BIN)/addons/$(PREFIX)_%.pbo, $(wildcard addons/*)) \
		$(patsubst optionals/%, $(BIN)/optionals/$(PREFIX)_%.pbo, $(wildcard optionals/*))

filepatching:
	"$(MAKE)" $(MAKEFLAGS) FLAGS="-w unquoted-string -p"

$(BIN)/keys/%.biprivatekey:
	@mkdir -p $(BIN)/keys
	@echo "  KEY  $@"
	@${ARMAKE} keygen -f $(patsubst $(BIN)/keys/%.biprivatekey, $(BIN)/keys/%, $@)

$(BIN)/addons/$(PREFIX)_%.pbo.$(PREFIX)_$(VERSION)-$(GIT_HASH).bisign: $(BIN)/addons/$(PREFIX)_%.pbo $(BIN)/keys/$(PREFIX)_$(VERSION).biprivatekey
	@echo "  SIG  $@"
	@${ARMAKE} sign -f -s $@ $(BIN)/keys/$(PREFIX)_$(VERSION).biprivatekey $<

signatures: $(patsubst addons/%, $(BIN)/addons/$(PREFIX)_%.pbo.$(PREFIX)_$(VERSION)-$(GIT_HASH).bisign, $(wildcard addons/*)) \
		$(patsubst optionals/%, $(BIN)/optionals/$(PREFIX)_%.pbo.$(PREFIX)_$(VERSION)-$(GIT_HASH).bisign, $(wildcard optionals/*))

version:
	@echo "  VER  $(VERSION)"
	$(shell sed -i -r -s 's/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/$(VERSION)/g' $(VERSION_FILES))
	$(shell sed -i -r -s 's/[0-9]+\.[0-9]+\.[0-9]+/$(VERSION_S)/g' $(VERSION_FILES))
	@echo -e "#define MAJOR $(MAJOR)\n#define MINOR $(MINOR)\n#define PATCHLVL $(PATCH)\n#define BUILD $(BUILD)" > "addons/main/script_version.hpp"

commit:
	@echo "  GIT  commit release preparation"
	@git add -A
	@git diff-index --quiet HEAD || git commit -am "Prepare release $(VERSION_S)" -q

push: commit
	@echo "  GIT  push release preparation"
	@git push -q

release: clean version commit
	@"$(MAKE)" $(MAKEFLAGS) signatures
	@echo "  ZIP  $(ZIP)_$(VERSION_S).zip"
	@cp *.dll mod.cpp README.md docs/README_DE.md docs/README_PL.md AUTHORS.txt LICENSE logo_ace3_ca.paa meta.cpp $(BIN)
	@zip -qr $(ZIP)_$(VERSION_S).zip $(BIN)

clean:
	rm -rf $(BIN) $(ZIP)_*.zip

.PHONY: all filepatching signatures extensions extensions-win64 version commit push release clean
