build:
	@cd static && elm make src/Main.elm
	@cp static/index.html index.html
	@cabal build

.PHONY: build
