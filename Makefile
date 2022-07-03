default: docker_build
include .env

# Note: 
#	Latest version of kubectl may be found at: https://github.com/kubernetes/kubernetes/releases
# Latest version of helm may be found at: https://github.com/kubernetes/helm/releases
VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))
DOCKER_IMAGE ?= nirmata/alpine-kubectl-helm-kustomize
DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`

docker_build:
	@docker buildx build \
	  --build-arg KUBECTL_VERSION=$(KUBECTL_VERSION) \
	  --build-arg HELM_VERSION=$(HELM_VERSION) \
	  --build-arg KUSTOMIZE_VERSION=$(KUSTOMIZE_VERSION) \
	  --build-arg TARGETOS=$(TARGETOS) \
	  --build-arg TARGETARCH=$(TARGETARCH) \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

