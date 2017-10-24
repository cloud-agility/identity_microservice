DOCKER_IMAGE = sample/hello
RUN_BUILD    = docker build
RUN_TEST     = docker run -it --rm
TEST_CMD     = npm test
TEST_DIR     = test

.PHONY: all
all: build test

.PHONY: build
build: Dockerfile
	echo ">> building app"
	$(RUN_BUILD) -t $(DOCKER_IMAGE) .

.PHONY: test
test:
	echo ">> running tests"
	$(RUN_TEST) -v$(CURDIR)/$(TEST_DIR):/src/$(TEST_DIR) -w /src $(DOCKER_IMAGE) $(TEST_CMD)
