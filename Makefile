WORKDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKER_REPO := ghcr.io/leviable
NAME := apk-builder
ALPINE_VERSION ?= 3.13
IMAGE := $(DOCKER_REPO)/$(NAME):$(ALPINE_VERSION)

DOCKER_BUILDKIT ?= 1

.PHONY: build
build:
	docker build \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		-t  $(IMAGE) .

.PHONY: shell
shell:
	docker run --rm -it \
		-e PACKAGER_PRIVKEY=/home/builder/.abuild/builder.rsa \
		-v `pwd`:/apk-builder \
		-v `pwd`/keys/builder.rsa:/home/builder/.abuild/builder.rsa \
		-v `pwd`/keys/builder.rsa.pub:/home/builder/.abuild/builder.rsa.pub \
		$(IMAGE)

.PHONY: run
run:
	docker run --rm -it $(IMAGE) ls -al /

.PHONY: tag-latest
tag-latest:
	docker tag $(IMAGE) $(DOCKER_REPO)/$(NAME):latest

.PHONY: push
push:
	docker push $(IMAGE)

.PHONY: push-latest
push-latest:
	docker push $(DOCKER_REPO)/$(NAME):latest
