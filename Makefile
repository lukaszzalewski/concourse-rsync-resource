SHELL=/bin/bash
CONTAINER_NAME:='justonecommand/concourse-rsync-resource'
CONTAINER_TAG:='0.15'

all: build upload

build:
	docker build -t ${CONTAINER_NAME}:${CONTAINER_TAG} .

upload:
	docker push ${CONTAINER_NAME}:${CONTAINER_TAG}
