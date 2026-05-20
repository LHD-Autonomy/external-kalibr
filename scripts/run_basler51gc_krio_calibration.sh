#!/usr/bin/env bash
set -e

# --- Files ---
BAG="/data/20260519_170959_bolzano_kalibr_basler/20260519_170959_kalibr_rope_bolzano_basler.orig.bag"
CAM="/workspace/config/fb3-2026-05/basler51gc_pixhawk_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/krio_calibration.yaml"
TARGET="/workspace/config/fb3-2026-05/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source /workspace/devel/setup.bash

# --- Run ---
rosrun kalibr kalibr_calibrate_imu_camera \
  --bag "$BAG" \
  --cam "$CAM" \
  --imu "$IMU" \
  --target "$TARGET"