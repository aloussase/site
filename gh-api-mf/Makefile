# NOTE: The sed command in this Makefile works for macOS
# For Linux, remove the empty string after the -i

APPNAME := gh_api_mf

dev:
	gleam run -m lustre/dev start

build:
	gleam run -m lustre/dev build app --minify

docker: build
	docker buildx build --platform linux/amd64,linux/arm64 -t aloussase/gh-api-mf --push .

.PHONY: dev build
