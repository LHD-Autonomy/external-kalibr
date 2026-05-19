# ------------------------------------------------
# ------------ Kalibr utils  ---------------
# ------------------------------------------------
kalibr-build:
	@cd ./src/libs/sensors/submodules/kalibr && docker build -t kalibr -f Dockerfile_ros1_20_04 . && cd ../../../../../

kalibr-run:
	@echo "To generate an AprilTag, run:"
	@echo "python3 /catkin_ws/src/kalibr/aslam_offline_calibration/kalibr/python/kalibr_create_target_pdf --type apriltag --nx 7 --ny 5 --tsize 0.04 --tspace 0.3"
	@echo "chmod 777 target.pdf && mv target.pdf /data/"
	@echo ""
	@ \
	CONTAINER_NAME=kalibr_container && \
	IMAGE_NAME=kalibr && \
	if [ "$$(docker ps -q -f name=$$CONTAINER_NAME)" ]; then \
		echo "Attaching to Kalibr running container..."; \
		docker exec -it $$CONTAINER_NAME bash -c '\
			source /opt/ros/noetic/setup.bash && \
			if [ -f /kalibr/install/setup.bash ]; then source /kalibr/install/setup.bash; \
			elif [ -f /kalibr/devel/setup.bash ]; then source /kalibr/devel/setup.bash; fi && \
			exec bash'; \
	elif [ "$$(docker ps -aq -f name=$$CONTAINER_NAME)" ]; then \
		echo "Starting existing Kalibr container..."; \
		docker start $$CONTAINER_NAME && \
		docker exec -it $$CONTAINER_NAME bash -c '\
			source /opt/ros/noetic/setup.bash && \
			if [ -f /kalibr/install/setup.bash ]; then source /kalibr/install/setup.bash; \
			elif [ -f /kalibr/devel/setup.bash ]; then source /kalibr/devel/setup.bash; fi && \
			exec bash'; \
	else \
		echo "Creating new Kalibr container..."; \
		docker run -it \
			--name $$CONTAINER_NAME \
			-e DISPLAY \
			-e QT_X11_NO_MITSHM=1 \
			-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
			-v "$$PWD:/workspace" \
			$$IMAGE_NAME \
			bash -c '\
				source /opt/ros/noetic/setup.bash && \
				if [ -f /kalibr/install/setup.bash ]; then source /kalibr/install/setup.bash; \
				elif [ -f /kalibr/devel/setup.bash ]; then source /kalibr/devel/setup.bash; fi && \
				exec bash'; \
	fi

kalibr-del:
	@CONTAINER_NAME=kalibr_container && \
	if [ "$$(docker ps -q -f name=$$CONTAINER_NAME)" ]; then \
		echo "Stopping Kalibr container..."; \
		docker stop $$CONTAINER_NAME >/dev/null; \
	fi; \
	if [ "$$(docker ps -aq -f name=$$CONTAINER_NAME)" ]; then \
		echo "Removing Kalibr container..."; \
		docker rm $$CONTAINER_NAME >/dev/null; \
		echo "Kalibr Container removed."; \
	else \
		echo "No container named $$CONTAINER_NAME found."; \
	fi