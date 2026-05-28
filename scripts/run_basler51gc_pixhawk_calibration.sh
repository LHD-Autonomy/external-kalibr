#!/usr/bin/env bash
set -e

# --- Files ---
BAG="/data/20260519_bolzano_integration_day4/20260519_bolzano_calibrations/20260519_170959_bolzano_kalibr_basler/20260519_170959_bolzano_kalibr_basler_db3_ros1_rosbag_0.bag"
CAM="/workspace/config/fb3-2026-05/basler51gc_pixhawk_camchain.yaml"
IMU="/workspace/config/fb3-2026-05/pixhawk_calibration.yaml"
TARGET="/workspace/config/fb3-2026-05/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source /workspace/devel/setup.bash

# --- Parameters ---
START_OFFSET=60
END_OFFSET=80

# Resolve the cropped bag name natively to pass to Kalibr
CROPPED_BAG="${BAG%.bag}_cropped.bag"

# --- Step 1: Call External Crop Tool ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/crop_bag.sh" "$BAG" "$START_OFFSET" "$END_OFFSET"

# --- Step 2: Run Calibration ---
echo "--- Running Kalibr calibration ---"
rosrun kalibr kalibr_calibrate_imu_camera \
  --bag "$CROPPED_BAG" \
  --cam "$CAM" \
  --imu "$IMU" \
  --target "$TARGET" \
  --max-iter 10 \
  --timeoffset-padding 0.2 \
  --dont-show-report

echo "--- Done! (Cached file retained at $CROPPED_BAG) ---"