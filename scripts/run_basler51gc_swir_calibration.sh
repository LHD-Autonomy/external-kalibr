#!/usr/bin/env bash
set -e

# --- Files ---
# BAG="/data/20260519_170959_bolzano_kalibr_basler/20260519_170959_kalibr_rope_bolzano_basler.orig.bag"
BAG="/data/20260519_170307_bolzano_rope_bringup/20260519_170307_kalibr_rope_bolzano_swir.orig.bag"

CAM="/workspace/config/fb3-2026-05/basler51gc_pixhawk_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/pixhawk_calibration.yaml"
TARGET="/workspace/config/fb3-2026-05/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source /workspace/devel/setup.bash

# --bag /data/cam_april.bag --target /data/april_6x6.yaml \ --models pinhole-radtan pinhole-radtan \ --topics /cam0/image_raw /cam1/image_raw

# --- Run ---
rosrun kalibr kalibr_calibrate_cameras \
  --bag "$BAG" \
  --topics /basler51gc_camera/image /allied_vision_swr_camera/image \
  --models pinhole-radtan pinhole-radtan \
  --target "$TARGET"