include ../../../make.inc

.PHONY: build_docker_image run_docker_image push_docker_image deploy

# YOUR CODE HERE
build_docker_image:
	docker build -t "$$DOCKER_IMAGE_NAME" .

run_docker_image:
	docker run --rm -e PORT="$$PORT" -p 8000:"$$PORT" "$$DOCKER_IMAGE_NAME"

push_docker_image:
	docker push "$$DOCKER_IMAGE_NAME"
deploy_docker_image:
	gcloud run deploy nonroot-image-fastapi \
	--image "$$DOCKER_IMAGE_NAME" \
	--region "$$LOCATION" \
	--allow-unauthenticated
