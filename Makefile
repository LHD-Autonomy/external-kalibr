# ------------------------------------------------
# ------------ Kalibr utils  ---------------
# ------------------------------------------------
.PHONY: kalibr-build kalibr-run kalibr-del
.PHONY: kalibr-calibrate-swir-krio       kalibr-calibrate-swir-pixhawk 
.PHONY: kalibr-calibrate-basler51gc-krio kalibr-calibrate-basler51gc-pixhawk
.PHONY: kalibr-calibrate-basler51gc-swir

kalibr-build:
	@docker build -t kalibr -f Dockerfile_ros1_20_04 . && cd ../../../../../

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
			if [ -f /catkin_ws/install/setup.bash ]; then source /catkin_ws/install/setup.bash; \
			elif [ -f /catkin_ws/devel/setup.bash ]; then source /catkin_ws/devel/setup.bash; fi && \
			exec bash'; \
	elif [ "$$(docker ps -aq -f name=$$CONTAINER_NAME)" ]; then \
		echo "Starting existing Kalibr container..."; \
		docker start $$CONTAINER_NAME && \
		docker exec -it $$CONTAINER_NAME bash -c '\
			source /opt/ros/noetic/setup.bash && \
			if [ -f /catkin_ws/install/setup.bash ]; then source /catkin_ws/install/setup.bash; \
			elif [ -f /catkin_ws/devel/setup.bash ]; then source /catkin_ws/devel/setup.bash; fi && \
			exec bash'; \
	else \
		echo "Creating new Kalibr container..."; \
		docker run -it \
			--name $$CONTAINER_NAME \
			-e DISPLAY \
			-e QT_X11_NO_MITSHM=1 \
			-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
			-v "$$PWD/../enhanced-sensing:/enhanced-sensing" \
			-v "$$PWD:/workspace" \
			-v "/media/ms2/266F8F203987DFF75/FB3_2026_ordered:/data" \
			$$IMAGE_NAME \
			bash -c '\
				source /opt/ros/noetic/setup.bash && \
				if [ -f /catkin_ws/install/setup.bash ]; then source /catkin_ws/install/setup.bash; \
				elif [ -f /catkin_ws/devel/setup.bash ]; then source /catkin_ws/devel/setup.bash; fi && \
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

kalibr-calibrate-swir-pixhawk:
	@if [ -f /.dockerenv ]; then \
		clear && bash ./scripts/run_allied_vision_swir_pixhawk_calibration.sh; \
	else \
		echo "Run this inside the Kalibr container (make kalibr-run)"; \
	fi

kalibr-calibrate-basler51gc-pixhawk:
	@if [ -f /.dockerenv ]; then \
		clear && bash ./scripts/run_basler51gc_pixhawk_calibration.sh; \
	else \
		echo "Run this inside the Kalibr container (make kalibr-run)"; \
	fi

kalibr-calibrate-basler51gc-krio:
	@if [ -f /.dockerenv ]; then \
		clear && bash ./scripts/run_basler51gc_krio_calibration.sh; \
	else \
		echo "Run this inside the Kalibr container (make kalibr-run)"; \
	fi

kalibr-calibrate-basler51gc-swir:
	@if [ -f /.dockerenv ]; then \
		clear && bash ./scripts/run_basler51gc_swir_calibration.sh; \
	else \
		echo "Run this inside the Kalibr container (make kalibr-run)"; \
	fi