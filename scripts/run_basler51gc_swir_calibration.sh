#!/usr/bin/env bash
set -e

# --- Files ---
# BAG="/data/20260519_170959_bolzano_kalibr_basler/20260519_170959_kalibr_rope_bolzano_basler.orig.bag"
# BAG="/data/20260519_170307_bolzano_rope_bringup/20260519_170307_kalibr_rope_bolzano_swir.orig.bag"
# BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/kalibr_processed/kalibr_basler_swir_only_motion_db3_smooth_rosbag_ros1.bag"
BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/kalibr_processed/kalibr_basler_swir_full_db3_ros1.bag"

CAMS="/workspace/config/fb3-2026-05/basler51gc_swir_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/pixhawk_calibration.yaml"
TARGET="/workspace/config/fb3-2026-05/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source /workspace/devel/setup.bash

# --- Run ---
export MPLBACKEND=Agg

echo "Starting Kalibr Multi-Camera Calibration..."
rosrun kalibr kalibr_calibrate_cameras \
  --bag "$BAG" \
  --topics /basler51gc_camera/image /allied_vision_swir_camera/image \
  --models pinhole-radtan pinhole-radtan \
  --target "$TARGET" \
  --bag-freq 2.0 \
  --dont-show-report