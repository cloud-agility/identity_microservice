RELEASE		 	 = 0.1
ifdef TRAVIS_PULL_REQUEST_SHA
	VERSION		 = $(TRAVIS_PULL_REQUEST_SHA)
else
	VERSION			 = local
endif
DOCKER_IMAGE = cloudagility/node_sample:$(VERSION)
RUN_BUILD    = docker build
RUN_TEST     = docker run -it --rm
TEST_CMD     = npm test
TEST_DIR     = test
RUN_DEPLOY	 = kubectl apply
DEPLOYMENT	 = kubernetes/deployment.yaml
SERVICE			 = kubernetes/service.yaml
PUSH 				 = docker push

.PHONY: all
all: build test deploy

.PHONY: build
build: Dockerfile
	echo ">> building app $(VERSION)"
	$(RUN_BUILD) -t $(DOCKER_IMAGE) .

.PHONY: test
test:
	echo ">> running tests $(VERSION)"
	$(RUN_TEST) -v$(CURDIR)/$(TEST_DIR):/src/$(TEST_DIR) -w /src $(DOCKER_IMAGE) $(TEST_CMD)

.PHONY: push
push:
ifeq ($(VERSION),local)
	echo ">> using local registry"
else
	echo ">> pushing image to docker hub $(VERSION)"
	#$(PUSH) $(DOCKER_IMAGE)
endif

.PHONY: deploy
deploy: push
ifeq ($(VERSION),local)
	echo ">> deploying app to local kubernetes cluster"
	#$(PUSH) $(DOCKER_IMAGE)
	$(RUN_DEPLOY) -f $(DEPLOYMENT)
	$(RUN_DEPLOY) -f $(SERVICE)
else
	echo ">> deploying app $(VERSION) to production (TODO)"
endif
