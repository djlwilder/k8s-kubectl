ARCH?=amd64
ifeq ($(ARCH),amd64)
        ARCHTAG?=
endif

ifeq ($(ARCH),ppc64le)
        ARCHTAG:=-ppc64le
endif

default: docker_build

DOCKER_IMAGE ?= lachlanevenson/k8s-kubectl$(ARCHTAG)
GIT_BRANCH ?= `git rev-parse --abbrev-ref HEAD`

ifeq ($(GIT_BRANCH), master)
	DOCKER_TAG = latest
else
	DOCKER_TAG = $(GIT_BRANCH)
endif

docker_build:
	@docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f Dockerfile$(ARCHTAG) .
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

test:
	docker run $(DOCKER_IMAGE):$(DOCKER_TAG) version --client
