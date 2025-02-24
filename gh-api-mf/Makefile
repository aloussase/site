# NOTE: The sed command in this Makefile works for macOS
# For Linux, remove the empty string after the -i

APPNAME := gh_api_mf

dev:
	sed -i '' "s|issues/priv/static/${APPNAME}.min.mjs|priv/static/${APPNAME}.mjs|" index.html
	sed -i '' "s|issues/priv/static/${APPNAME}.min.css|priv/static/${APPNAME}.css|" index.html
	gleam run -m lustre/dev start

build:
	gleam run -m lustre/dev build app --minify
	sed -i '' "s|priv/static/${APPNAME}.mjs|issues/priv/static/${APPNAME}.min.mjs|" index.html
	sed -i '' "s|priv/static/${APPNAME}.css|issues/priv/static/${APPNAME}.min.css|" index.html

docker: build
	docker buildx build --platform linux/amd64,linux/arm64 -t aloussase/gh-api-mf --push .

.PHONY: dev build
