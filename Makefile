GO_BUILDER_IMAGE=golang:alpine
IMAGE_TAG=go-app:latest

all: go_build docker_build clean

go_build:
	docker run --rm -v "$(PWD)":/usr/src/myapp -w /usr/src/myapp -e CGO_ENABLED=0 -e GOOS=linux ${GO_BUILDER_IMAGE} go build -a -installsuffix cgo -o main -v .

docker_build:
	docker build . -t ${IMAGE_TAG}

clean:
	rm main