PROGNAME := site
REMOTE_HOST := jupiter
REMOTE_USER := aloussase
REMOTE_PATH := /home/${REMOTE_USER}/.local/bin

reload:
	@echo "Reloading the server..."
	@templ generate && go build -o ${PROGNAME} && ./${PROGNAME}

build: build-amd64 build-arm64

build-amd64:
	@echo "Building application for host platform"
	@mkdir -p build/amd64
	@go build -o build/amd64/${PROGNAME}

build-arm64:
	@echo "Building application for ARM64"
	@mkdir -p build/arm64
	@GOOS=linux GOARCH=arm64 go build -o build/arm64/${PROGNAME}
	
deploy: build
	@echo "Deploying application to the server"
	@scp build/arm64/${PROGNAME} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/${PROGNAME}
	@scp -r assets ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/assets


.PHONY: reload build build-amd64 build-arm64 deploy
