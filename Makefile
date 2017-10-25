NAME		= node_sample
RELEASE		= 0.1
ifdef TRAVIS_COMMIT
	TAGS	= $(TRAVIS_COMMIT)
else
	TAGS	= local
endif
DOCKER_IMAGE	= $(NAME):$(TAGS)
DEPLOYMENT	= kubernetes/deployment.yaml
SERVICE		= kubernetes/service.yaml

#REGISTRY	= mycluster.icp:8500/default
#LOCAL		= icp
LOCAL		= minikube
REGISTRY	= localhost:5000

# COMMAND DEFINITIONS
BUILD		= docker build -t
TEST		= docker run -it --rm
TEST_CMD	= npm test
TEST_DIR	= test
DEPLOY		= kubectl apply
DEPLOY_OPTS = --validate=false
PUSH		= docker push
TAG		= docker tag

.PHONY: all
all: build test deploy

.PHONY: build
build: Dockerfile
	echo ">> building app as $(DOCKER_IMAGE)"
	$(BUILD) $(DOCKER_IMAGE) .

.PHONY: test
test:
	echo ">> running tests on $(DOCKER_IMAGE)"
	$(TEST) -v$(CURDIR)/$(TEST_DIR):/src/$(TEST_DIR) -w /src $(DOCKER_IMAGE) $(TEST_CMD)

.PHONY: push
push:
ifeq ($(TAGS),local)
	echo ">> using $(REGISTRY) registry"
	$(TAG) $(DOCKER_IMAGE) $(REGISTRY)/$(DOCKER_IMAGE)
	$(PUSH) $(REGISTRY)/$(DOCKER_IMAGE)
else
	echo ">> pushing image to docker hub as $(DOCKER_IMAGE)"
	# docker login
	#$(PUSH) $(DOCKER_IMAGE)
endif

.PHONY: deploy
deploy: push
ifeq ($(TAGS),local)
	echo ">> deploying app to local $(LOCAL) cluster"
	$(DEPLOY) -f $(DEPLOYMENT) $(DEPLOY_OPTS)
	$(DEPLOY) -f $(SERVICE) $(DEPLOY_OPTS)
else
	echo ">> deploying app $(TAGS) to production (TODO)"
	#$(DEPLOY) -f $(DEPLOYMENT)
	#$(DEPLOY) -f $(SERVICE)
endif
