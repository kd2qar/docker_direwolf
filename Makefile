NAME=direwolf
TAG=direwolf/fastegium

DEVICE=/dev/ttyUSB0

PORT=-p 8515:8515 -p 8516:8516

PORT=-p 8001:8001 -p 8000:8000

#DEVICE="plughw:1,0"
#DEVICE=/dev/snd
DEV=--device ${DEVICE}:${DEVICE}
#DEVICE=
DEV=

DEVICE=--device=/dev/ttyUSB0

VOL=

PRIV="--privileged"

all:: build

run:
	#docker run -d --rm --restart=always ${DEV} ${PORT} ${VOL} --name ${NAME} ${TAG} 
	docker run -d --restart=unless-stopped -v /dev/snd:/dev/snd  ${PRIV}  ${DEV} ${PORT} ${VOL} --name ${NAME} ${TAG}

test: 
	docker run -it --rm --name testrun ${TAG}

build:
	docker build  --force-rm --tag=$(TAG) . 

remove:
	docker stop ${NAME} || true
	docker rm ${NAME} || true

shell:
	echo "NAME: '${NAME}_s'"
	docker run -it --rm ${DEV} -v /dev/snd:/dev/snd ${PRIV} ${PORT} ${VOL} --net host  --entrypoint /bin/bash --name ${NAME}_s ${TAG}
