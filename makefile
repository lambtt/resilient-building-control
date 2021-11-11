IMA_NAME = res_building_control

build:
	docker build --no-cache --rm -t ${IMA_NAME} .

remove_image:
	docker rmi ${IMA_NAME}
