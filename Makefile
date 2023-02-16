.PHONY: image test release

IMAGE_NAME ?= codeclimate/codeclimate-csslint
RELEASE_REGISTRY ?= codeclimate

ifndef RELEASE_TAG
override RELEASE_TAG = latest
endif

image:
	docker build -t codeclimate/codeclimate-csslint .

test: image
	docker run --rm codeclimate/codeclimate-csslint sh -c "cd /usr/src/app && npm run test"

release:
	docker tag $(IMAGE_NAME) $(RELEASE_REGISTRY)/codeclimate-csslint:$(RELEASE_TAG)
	docker push $(RELEASE_REGISTRY)/codeclimate-csslint:$(RELEASE_TAG)
