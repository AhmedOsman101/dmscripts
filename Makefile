# VARIABLES
SHELL = /bin/sh
NAME = dmscripts

HOME_DIR = /home/othman
INSTALL_DIR ?= $(HOME_DIR)/.local/bin

PREFIX ?= /usr
SCRIPTS := $(wildcard ./scripts/*)
SHARE != [ -d ${PREFIX}/share/man ] && echo /share || true
MANPREFIX ?= ${PREFIX}${SHARE}/man


build:
	@$(MAKE) man/dmscripts.1.gz
	@echo "Done"

./man/dmscripts.1.gz: ./man/man.org
	@pandoc -s -t man man/man.org -o man/dmscripts.1
	gzip man/dmscripts.1


install:
	install -Dm 775 $(SCRIPTS) -t $(INSTALL_DIR)/
	install -Dm 644 man/dmscripts.1.gz $(DESTDIR)$(MANPREFIX)/man1/dmscripts.1.gz
	install -Dm644 LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/LICENSE"
	install -Dm644 README.md "$(DESTDIR)$(PREFIX)/share/doc/$(NAME)/README.md"
	install -Dm644 config/config "$(DESTDIR)/etc/dmscripts/config"

uninstall:
	rm -f $(addprefix $(INSTALL_DIR)/,$(notdir $(SCRIPTS)))
	rm -f $(DESTDIR)$(MANPREFIX)/man1/dmscripts.1.gz
	rm -f "$(DESTDIR)$(PREFIX)/share/licenses/$(NAME)/LICENSE"
	rm -f "$(DESTDIR)$(PREFIX)/share/doc/$(NAME)/README.md"
	rm -f "$(DESTDIR)/etc/dmscripts/config"

list:
	@echo "Scripts installation directory: $(INSTALL_DIR)"
	@echo "Prefix: $(PREFIX)"
	@echo "Manprefix: $(MANPREFIX)"

clean:
	$(if $(wildcard man/dmscripts.1.gz), rm man/dmscripts.1.gz)
	@echo "done"

.PHONY: clean build install uninstall list
