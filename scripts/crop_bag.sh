#!/usr/bin/env bash
set -e

# Verify correct arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <PATH_TO_INPUT_BAG> <START_OFFSET_SEC> <END_OFFSET_SEC>"
    exit 1
fi

INPUT_BAG="$1"
START_OFFSET="$2"
END_OFFSET="$3"

# --- Bypass Check ---
if [ "$START_OFFSET" -eq -1 ] || [ "$END_OFFSET" -eq -1 ]; then
    echo "=================================================="
    echo "Utility Crop Module: BYPASS ACTIVE"
    echo "Reason             : Offset set to -1"
    echo "Action             : Using full original bag file."
    echo "=================================================="
    exit 0
fi

TARGET_DURATION=$((END_OFFSET - START_OFFSET))
CROPPED_BAG="${INPUT_BAG%.bag}_cropped.bag"
SHOULD_CROP=true

# Ensure environment has access to rosbag tool
if ! command -v rosbag &> /dev/null; then
    source /opt/ros/noetic/setup.bash
fi

# Parse Input Bag Start Epoch
BAG_START=$(rosbag info "$INPUT_BAG" | grep -E '^start:' | grep -oP '\(\d+' | tr -d '(')
FILTER_START=$((BAG_START + START_OFFSET))
FILTER_END=$((BAG_START + END_OFFSET))

echo "=================================================="
echo "Utility Crop Module"
echo "Parsed Start Epoch : $BAG_START"
echo "Target Window      : $FILTER_START to $FILTER_END ($TARGET_DURATIONs)"
echo "Output File        : $CROPPED_BAG"
echo "=================================================="

# --- Check if Valid Cached Bag Exists ---
if [ -f "$CROPPED_BAG" ]; then
    echo "Found existing bag at $CROPPED_BAG. Checking compatibility..."
    
    CACHED_START=$(rosbag info "$CROPPED_BAG" | grep -E '^start:' | grep -oP '\(\d+' | tr -d '(' || echo "0")
    CACHED_DURATION=$(rosbag info "$CROPPED_BAG" | grep -E '^duration:' | grep -oP '\(\d+' | tr -d '(' || echo "0")
    
    if [ "$CACHED_START" -eq "$FILTER_START" ] && [ "$CACHED_DURATION" -eq "$TARGET_DURATION" ]; then
        echo ">> Matching cached bag found! Skipping heavy crop step. <<"
        SHOULD_CROP=false
    else
        echo "Cached bag parameters mismatch (Start: $CACHED_START, Dur: ${CACHED_DURATION}s). Recropping..."
    fi
fi

# --- Crop Only If Needed ---
if [ "$SHOULD_CROP" = true ]; then
    echo "--- Cropping bag file from relative second $START_OFFSET to $END_OFFSET ---"
    rm -f "$CROPPED_BAG"
    rosbag filter "$INPUT_BAG" "$CROPPED_BAG" "t.to_sec() >= $FILTER_START and t.to_sec() <= $FILTER_END"
fi

# Final Size Safety Check
CROPPED_SIZE=$(du -k "$CROPPED_BAG" | cut -f1)
echo "Using Bag Size: $CROPPED_SIZE KB"

if [ "$CROPPED_SIZE" -lt 100 ]; then
    echo "ERROR: Cropped bag is empty or corrupt!"
    exit 1
fi