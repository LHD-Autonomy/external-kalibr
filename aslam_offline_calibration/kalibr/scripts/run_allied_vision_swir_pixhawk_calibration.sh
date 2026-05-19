rosrun kalibr kalibr_calibrate_imu_camera \
  --bag /data/20260519_170307_bolzano_rope_bringup/20260519_170307_kalibr_rope_bolzano_rosbag/20260519_170307_kalibr_rope_bolzano_rosbag_0.bag \
  --cam ../config/fb3-2026-05/allied_vision_swir_pixhawk_camchain.yaml \
  --imu ../config/fb3-2026-05/pixhawk_calibration.yaml \
  --target ../config/fb3-2026-05/calibration_target.yaml