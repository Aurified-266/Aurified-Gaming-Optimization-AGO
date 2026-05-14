#!/system/bin/sh
# Aurified-Gaming-Optimizer - Optimized for Retroid Pocket 5
# Author: Aurified.Dev

MODDIR=${0%/*}
sleep 15 # Wait for system to stabilize

# --- HELPER FUNCTIONS ---
get_max_freq() {
    local cpu=$1
    cat /sys/devices/system/cpu/cpu${cpu}/cpufreq/cpuinfo_max_freq 2>/dev/null || echo "0"
}

set_freq_safe() {
    local cpu=$1
    local min_val=$2
    local max_val=$3
    
    # Check if path exists
    if [ ! -f "/sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_min_freq" ]; then
        return 1
    fi

    # Validate values against hardware max
    local hw_max=$(get_max_freq $cpu)
    
    # If requested max is higher than hardware max, clamp it
    if [ "$max_val" -gt "$hw_max" ]; then
        max_val=$hw_max
    fi
    if [ "$min_val" -gt "$hw_max" ]; then
        min_val=$hw_max
    fi

    chmod 644 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor 2>/dev/null
    echo performance > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor 2>/dev/null
    chmod 444 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_governor 2>/dev/null

    chmod 644 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_min_freq 2>/dev/null
    echo $min_val > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_min_freq 2>/dev/null
    chmod 444 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_min_freq 2>/dev/null

    chmod 644 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_max_freq 2>/dev/null
    echo $max_val > /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_max_freq 2>/dev/null
    chmod 444 /sys/devices/system/cpu/cpu${cpu}/cpufreq/scaling_max_freq 2>/dev/null
}

# --- CPU OPTIMIZATION (Dynamic) ---
# Detect clusters (assuming 8-core layout: 4 Little, 4 Big)
# Adjust logic if R5P5 has different core count
LITTLE_CORES=(0 1 2 3)
BIG_CORES=(4 5 6 7)

# Get actual max frequencies from hardware
LITTLE_MAX=$(get_max_freq 0)
BIG_MAX=$(get_max_freq 4)

# Set Little Cores: High floor for responsiveness, max capped at hardware limit
for cpu in "${LITTLE_CORES[@]}"; do
    # Set min to 80% of max to prevent lag spikes, max to hardware limit
    MIN_FREQ=$((LITTLE_MAX * 80 / 100))
    set_freq_safe $cpu $MIN_FREQ $LITTLE_MAX
done

# Set Big Cores: Performance mode
for cpu in "${BIG_CORES[@]}"; do
    MIN_FREQ=$((BIG_MAX * 90 / 100)) # Keep big cores hot for burst
    set_freq_safe $cpu $MIN_FREQ $BIG_MAX
done

# --- GPU OPTIMIZATION (Smart Scaling) ---
# Instead of locking to max (which causes heat), we set a high MINIMUM 
# and allow dynamic MAX scaling to save battery during menus/idle.
GPU_PATH="/sys/class/kgsl/kgsl-3d0"

if [ -d "$GPU_PATH" ]; then
    # Get GPU max freq
    GPU_MAX=$(cat ${GPU_PATH}/gpuinfo_max_freq 2>/dev/null || echo "1260000000")
    
    # Set Minimum Frequency (Prevent stutter in games)
    GPU_MIN=$((GPU_MAX * 70 / 100)) 
    
    echo $GPU_MIN > ${GPU_PATH}/devfreq/min_freq 2>/dev/null
    echo $GPU_MAX > ${GPU_PATH}/devfreq/max_freq 2>/dev/null
    
    # Use 'performance' governor but allow scaling within range
    echo performance > ${GPU_PATH}/devfreq/governor 2>/dev/null
    
    # Power levels: Disable aggressive power saving
    echo 0 > ${GPU_PATH}/min_pwrlevel 2>/dev/null
    echo 0 > ${GPU_PATH}/max_pwrlevel 2>/dev/null
    
    # Clock MHz (Legacy path for compatibility)
    echo $((GPU_MAX / 1000000)) > ${GPU_PATH}/clock_mhz 2>/dev/null
    echo $((GPU_MAX / 1000000)) > ${GPU_PATH}/max_clock_mhz 2>/dev/null
    echo $((GPU_MAX / 1000000)) > ${GPU_PATH}/min_clock_mhz 2>/dev/null
    echo $GPU_MAX > ${GPU_PATH}/max_gpuclk 2>/dev/null
fi

# --- ZRAM OPTIMIZATION (Critical for Handhelds) ---
# Calculate 50% of total RAM (in KB) for ZRAM
TOTAL_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ZRAM_SIZE_KB=$((TOTAL_RAM_KB / 2))

if [ -f "/sys/block/zram0/initstate" ]; then
    # Reset ZRAM if it exists
    echo 0 > /sys/block/zram0/reset 2>/dev/null
    
    # Set Size
    echo $ZRAM_SIZE_KB > /sys/block/zram0/disksize 2>/dev/null
    
    # Set Compression Algorithm: 'zstd' offers best balance of speed/compression for gaming
    echo zstd > /sys/block/zram0/comp_algorithm 2>/dev/null
    
    # Re-init
    echo 1 > /sys/block/zram0/initstate 2>/dev/null
    mkswap /dev/block/zram0 2>/dev/null
    swapon -p 100 /dev/block/zram0 2>/dev/null
fi

# --- THERMAL SAFETY (Handheld Optimized) ---
# Prevent overheating in a small chassis. 
# Trip Point 1: Warning (80°C) - Throttle slightly
# Trip Point 2: Critical (85°C) - Aggressive Throttle
# Note: We do NOT disable thermal zones, which protects the battery during charging.
THERMAL_ZONE="/sys/class/thermal/thermal_zone0"
if [ -f "$THERMAL_ZONE/trip_point_1_temp" ]; then
    echo 80000 > $THERMAL_ZONE/trip_point_1_temp 2>/dev/null # 80°C
    echo 85000 > $THERMAL_ZONE/trip_point_2_temp 2>/dev/null # 85°C
fi

# --- KERNEL & SCHEDULER BOOSTS ---
# Enable input boost for immediate touch response
echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled 2>/dev/null
echo 1 > /sys/module/msm_performance/parameters/touchboost 2>/dev/null
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/boost 2>/dev/null

# Scheduler tweaks for gaming latency
echo 1 > /proc/sys/kernel/sched_boost 2>/dev/null
echo 0 > /sys/module/workqueue/parameters/power_efficient 2>/dev/null

# --- CHARGING SAFETY CHECK ---
# Ensure we don't override thermal limits that protect the battery during fast charge.
# We rely on the separate charging module for current/voltage control.
# This script only manages performance throttling based on temperature.

# --- SYSTEM COMMANDS ---
# Force fixed performance mode for the session
cmd power set-fixed-performance-mode-enabled true 2>/dev/null
cmd power set-adaptive-power-saver-enabled false 2>/dev/null
cmd power set-mode 0 2>/dev/null

# Ensure all cores are online
for i in $(seq 0 7); do
    echo 1 > /sys/devices/system/cpu/cpu$i/online 2>/dev/null
done

ui_print "Aurified-Gaming-Optimizer: Applied Retroid Pocket 5 Optimizations"
