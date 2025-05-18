build:
	@cd static && elm make src/Main.elm
	@cp static/index.html index.html
	@awk '/<\/style>/ {print "  <link href=\"/styles.css\" rel=\"stylesheet\"/>"} !/<\/style>/ {print $0}' index.html > tmp.html
	@mv -f tmp.html index.html
	@cabal build

.PHONY: build
