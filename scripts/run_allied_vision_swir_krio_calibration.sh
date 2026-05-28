#!/usr/bin/env bash
set -e

# --- Files ---
# BAG="/data/20260519_170307_bolzano_rope_bringup/20260519_170307_kalibr_rope_bolzano_swir.orig.bag"
BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/kalibr_processed/kalibr_basler_swir_only_motion_db3_smooth_continuous_ts2_ros1.bag"

CAM="/workspace/config/fb3-2026-05/allied_vision_swir_pixhawk_camchain.yaml"
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