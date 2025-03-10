PROGNAME := site
REMOTE_HOST := jupiter
REMOTE_USER := aloussase
REMOTE_PATH := /home/${REMOTE_USER}/.local/bin
SERVICE_FILE := site.service
SERVICE_PATH := /home/${REMOTE_USER}/.services
PATH_FILE := site.path

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
	@ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${SERVICE_PATH}"
	@scp build/arm64/${PROGNAME} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/${PROGNAME}
	@scp -r assets ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/assets
	@scp ${SERVICE_FILE} ${REMOTE_USER}@${REMOTE_HOST}:${SERVICE_PATH}/${SERVICE_FILE}
	@scp ${PATH_FILE} ${REMOTE_USER}@${REMOTE_HOST}:${SERVICE_PATH}/${PATH_FILE}


.PHONY: reload build build-amd64 build-arm64 deploy
