#!/usr/bin/env bash
set -e

# --- Files ---
BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/kalibr_processed/kalibr_basler_swir_reduced_db3_ros1/"
CAM="/workspace/config/fb3-2026-05/basler51gc_pixhawk_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/pixhawk_calibration.yaml"
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