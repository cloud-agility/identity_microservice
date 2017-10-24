MAJOR			 	 = 0.1
MINOR		 		 =  1
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
all: build test

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
	echo ">> pushing image to docker hub $(VERSION)"
	$(PUSH) $(DOCKER_IMAGE)

.PHONY: deploy
deploy: push
	echo ">> deploying app $(VERSION)"
	$(RUN_DEPLOY) -f $(DEPLOYMENT)
	$(RUN_DEPLOY) -f $(SERVICE)
