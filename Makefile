HUGO_VERSION = 0.64.0
THEME = strange-case

.PHONY: get
get:
	@echo "Checking for hugo"
	@if ! [ -x "$$(command -v hugo)" ]; then\
		echo "Getting Hugo";\
	    wget -q -P tmp/ https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_extended_$(HUGO_VERSION)_Linux-64bit.tar.gz;\
		tar xf tmp/hugo_extended_$(HUGO_VERSION)_Linux-64bit.tar.gz -C tmp/;\
		sudo mv -f tmp/hugo /usr/bin/;\
		rm -rf tmp/;\
		hugo version;\
	fi

.PHONY: modules-update
modules-update:
	git submodule update --recursive

.PHONY: setup
setup: modules-update get

.PHONY: server
server:
	@hugo server -D

.PHONY: deploy
deploy:
	@echo "Deploying updates to GitHub..."
	@hugo -D -t $(THEME)
	@cd public \
	&& git add . \
	&& git commit -m "rebuild site $(shell date)" \
	&& git push origin master
	@echo "Site is deployed!"
