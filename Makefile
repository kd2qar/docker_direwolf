NAME=direwolf
TAG=direwolf/kd2qar

DEVICE=/dev/ttyUSB0

PORT=-p 8001:8001 -p 8000:8000

#DEVICE="plughw:1,0"
#DEVICE=/dev/snd
DEV=--device ${DEVICE}:${DEVICE}
#DEVICE=
DEV=

DEVICE=--device=/dev/ttyUSB0

VOL=-v /dev/snd:/dev/snd

PRIV="--privileged"

all:: build

run:
	docker run -d --restart=unless-stopped  ${PRIV}  ${DEV} ${PORT} ${VOL} --name ${NAME} ${TAG}

test: 
	docker run -it --rm --name testrun ${TAG}

build:
	docker build  --force-rm --tag=$(TAG) . 

remove:
	docker stop ${NAME} || true
	docker rm ${NAME} || true

shell:
	echo "NAME: '${NAME}_s'"
	docker run -it --rm ${DEV} ${PRIV} ${PORT} ${VOL} --net host  --entrypoint /bin/bash --name ${NAME}_shell ${TAG}
