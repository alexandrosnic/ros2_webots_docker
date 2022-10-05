NVIDIA_GPU	!= command -v nvidia-smi 1>/dev/null 2>/dev/null && echo '--gpus all -e NVIDIA_DRIVER_CAPABILITIES=all'

docker-prepare-%:
	docker kill ccbts-$* || true
	docker rm ccbts-$* || true
	docker build . -t ccbts --build-arg user_id=${UID}

docker-run-prod:
	docker run -e PLATFORM=prod \
		--net=host \
		--cap-add SYS_ADMIN \
		--restart unless-stopped \
		--name ccbts-prod \
		-d -it ccbts

docker-run-devel:
	docker run -e DISPLAY -e PLATFORM=devel \
		--gpus=all \
		-v ${SRC}:/ccbts/cocobots_ws:rw \
		-v ~/.Xauthority:/ccbts/.Xauthority:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
		-v /dev/dri:/dev/dri:ro ${NVIDIA_GPU} \
		-p 50001-50003:50001-50003 \
		-p 29999:29999 \
		-p 30001-30003:30001-30003 \
		--device-cgroup-rule='c 189:* rmw' 
		--net=host \
		--cap-add SYS_ADMIN \
		--restart unless-stopped \
		--name ccbts-devel \
		-d -it ccbts

docker-restart-%:
	docker restart ccbts-$*

docker-logs-%:
	docker logs --follow ccbts-$*

bash-%:
	@docker exec -it ccbts-$* bash
