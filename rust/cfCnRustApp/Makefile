.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Cloudfoundry requires all applications that directly provide their docker-image,
# the domain of the registry and the name of the repository.
# 🚧 To-do: You need to adapt these parameters with those for your own repository.
DOCKER_REGISTRY := docker.io
DOCKER_REPOSITORY := cf-rust-app

BUILDPACK := paketo-community/rust@0.25.0

# 🚧 To-do: Adapt “rust_project_name”: It should match package name in Cargo.toml.
rust_project_name := cf-rust-app
rust_src_files = $(shell find ./src -name '*.rs')

# Name of the app for cloudfoundry: It should match the one in the manifest.yaml.
app_name := $(rust_project_name)

# This target creates a docker-image of the whole application, stores it in the local
# docker registry and exports the file-system of the docker-image. The latter serves for
# both: as marker that the image already has been created as well as for easy
# inspection of the image's content.
buildpacks-image: ./target/$(rust_project_name).image-buildpack.tar.zst
./target/$(rust_project_name).image-buildpack.tar.zst: Cargo.toml $(rust_src_files)
	mkdir --parents './target'
	pack build '$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY)' --buildpack='$(BUILDPACK)'
	docker image save '$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):latest' | zstd > './target/$(rust_project_name).image-buildpack.tar.zst'

# Supposed to work with the tags created by this file, e.g.: “latest”, …
docker-release-%:
	@ARTIFACT="$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY):$*"
	@echo "Uploading image" "$${ARTIFACT}"
	@docker push "$${ARTIFACT}"

.PHONY: cf-push
cf-push:
	@echo "Selected docker registry: $(DOCKER_REGISTRY)"
	@echo 'username to use: '
	@read CF_DOCKER_USERNAME
	cf push '$(app_name)' --docker-image='$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY)' --docker-username=$${CF_DOCKER_USERNAME}

clean: ./target
	rm --recursive --force ./target
	images_to_remove="$(shell docker images --format '{{.Repository}}:{{.Tag}}' --filter='reference=$(DOCKER_REGISTRY)/$(DOCKER_REPOSITORY)*')"
	docker image remove $${images_to_remove}