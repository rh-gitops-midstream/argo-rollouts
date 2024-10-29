
# Tool to build the container image. It can be either docker or podman
DOCKER ?= docker

build-plugin:
	$(DOCKER) build  -t argo-rollouts-cli-image -f ./Containerfile.plugin  .