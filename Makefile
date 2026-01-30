IMAGE ?= uvk1-uvk5v3

.PHONY: compile clean docker-build docker-shell docker-run

compile: clean
	./compile-with-docker.sh

clean:
	rm -rf build

# ============== Docker commands ==============

# Build the Docker image
docker-build:
	docker build -t $(IMAGE) .

# Run an interactive shell inside the build container
docker-shell:
	docker run --rm -it -v "$(PWD)":/src -w /src $(IMAGE) bash 

# Run a command inside the build container
# Usage: make docker-run CMD="your command"
docker-run:
	docker run --rm -it -v "$(PWD)":/src -w /src $(IMAGE) bash -c "$(CMD)"
