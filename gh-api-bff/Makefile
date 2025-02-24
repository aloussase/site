TAGNAME := aloussase/gh-api-bff

build:
	docker build --platform linux/amd64,linux/arm64 -t ${TAGNAME} .

publish: build
	docker push ${TAGNAME}

.PHONY: build publish
