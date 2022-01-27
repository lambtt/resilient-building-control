docker run \
      --user=root \
	  --detach=false \
	  -e DISPLAY=${DISPLAY} \
	  -v /tmp/.X11-unix:/tmp/.X11-unix\
	  --rm \
	  -v `pwd`:/mnt/shared \
	  -i \
      -t \
	  res_building_control \
	  /bin/bash -c "cd /mnt/shared && python2 /mnt/shared/compile.py"
