#!/usr/bin/env bash
set -e

# --- Base paths ---
WS=/catkin_ws
BASE=/catkin_ws/src/kalibr/aslam_offline_calibration/kalibr/

DATA=/data/fb3_2026-05

# --- Files ---
BAG="$DATA/20260519_170959_bolzano_kalibr_basler/20260519_170959_kalibr_rope_bolzano_rosbag/20260519_170959_kalibr_rope_bolzano_rosbag_0.bag"

CAM="$BASE/config/fb3-2026-05/basler51gc_pixhawk_camchain.yaml"
IMU="$BASE/config/fb3-2026-05/pixhawk_calibration.yaml"
TARGET="$BASE/config/calibration_target.yaml"

# --- Environment ---
source /opt/ros/noetic/setup.bash
source $WS/devel/setup.bash

# --- Run ---
rosrun kalibr kalibr_calibrate_imu_camera \
  --bag "$BAG" \
  --cam "$CAM" \
  --imu "$IMU" \
  --target "$TARGET"