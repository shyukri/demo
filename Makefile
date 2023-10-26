# Image values
REGISTRY ?= docker.io
PROJECT ?= shyukri
IMAGE ?= demo
IMAGE_REF := $(REGISTRY)/$(PROJECT)/$(IMAGE)
SHELL:=/bin/bash
# Git commit hash
HASH := $(shell git rev-parse --short HEAD)

.PHONY: build tag push clean argocd check-certificate

build:
	cd hello-app && \
	podman build --manifest $(PROJECT)/$(IMAGE) --arch arm64 --tag $(IMAGE_REF):$(HASH) . && \
	podman build --manifest $(PROJECT)/$(IMAGE) --arch amd64 --tag $(IMAGE_REF):$(HASH) .
tag:
	podman tag $(IMAGE_REF):$(HASH) $(IMAGE_REF):latest

push:
	podman manifest push --all $(PROJECT)/$(IMAGE)

clean:
	podman manifest rm $(PROJECT)/$(IMAGE) || true

argocd:
	helm repo add argo https://argoproj.github.io/argo-helm && \
	helm upgrade --install argo-cd argo/argo-cd \
		--namespace argocd \
		--wait \
		--create-namespace \
		--set fullnameOverride=argocd

check-certificate:
	echo | openssl s_client -connect crate-demo.example.com:443 2>&1 | openssl x509 -noout -text | grep -A2 -E 'Issuer|DNS|Validity'