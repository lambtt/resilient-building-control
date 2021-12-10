docker run \
	--user=root \
	--detach=false \
	-e DISPLAY=${DISPLAY} \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	--rm \
	-v `pwd`:/mnt/shared \
	-i \
	-t \
	res_building_control /bin/bash -c \
	"cd /mnt/shared && bash generate_fmu.sh"  
