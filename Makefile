DOCKER_IMAGE = hello

.PHONY: all
all: build test

.PHONY: build
build: 
	docker build -t $(DOCKER_IMAGE) .

.PHONY: install
install: package-lock.json

package-lock.json:
	docker run --rm -v$(CURDIR):/mnt -w /mnt node npm install

.PHONY: test
test: install
	echo ">> running tests"
	docker run -it --rm -v$(CURDIR):/mnt -w /mnt node npm test
