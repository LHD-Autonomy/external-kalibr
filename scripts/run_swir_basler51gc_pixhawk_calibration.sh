#!/usr/bin/env bash
set -e

# --- Files ---
BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/kalibr_processed/kalibr_basler_swir_only_motion_db3_smooth_rosbag_ros1.bag"

# 1. CRITICAL: Point this to the new file containing BOTH cameras and the T_cn_cnm1 baseline matrix
CAM="/workspace/config/fb3-2026-05/basler_swir_locked_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/pixhawk_calibration.yaml"
TARGET="/workspace/config/fb3-2026-05/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source /workspace/devel/setup.bash

# --- Run ---
export MPLBACKEND=Agg

echo "Running Camera-IMU Calibration with fixed stereo baseline..."
rosrun kalibr kalibr_calibrate_imu_camera \
  --bag "$BAG" \
  --cams "$CAM" \
  --imu "$IMU" \
  --target "$TARGET" \
  --bag-freq 10 \
  --max-iter 25 \
  --dont-show-report