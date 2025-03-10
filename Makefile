TAGNAME := aloussase/site:latest

reload:
	@echo "Reloading the server..."
	@templ generate && go build && ./site

build:
	@echo "Building the server..."
	@docker build --platform linux/amd64,linux/arm64 -t ${TAGNAME} . --push
	
