.PHONY: test

image:
	docker build -t codeclimate/codeclimate-csslint .

test: image
	docker run --rm codeclimate/codeclimate-csslint sh -c "cd /usr/src/app && npm run test"
