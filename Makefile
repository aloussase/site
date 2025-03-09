build:
	docker buildx build --platform linux/amd64,linux/arm64 -t aloussase/site:latest .

publish: build
	docker push aloussase/site:latest

.PHONY: build
