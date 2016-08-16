.PHONY: test

image:
	docker build -t codeclimate/codeclimate-csslint .

test: image
	docker run --rm codeclimate/codeclimate-csslint rspec $(RSPEC_ARGS)
