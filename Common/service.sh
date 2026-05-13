#!/system/bin/sh
sleep 20

# Set small CPU cores (0-3) to performance mode
for cpu in 0 1 2 3; do
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    echo performance > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    echo 1900800 > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
    echo 1900800 > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
done

# Set big CPU cores (4-7) to performance mode
for cpu in 4 5 6 7; do
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    echo performance > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    echo 2802300 > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_min_freq
    chmod 644 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
    echo 2802300 > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
    chmod 444 /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_max_freq
done

# GPU max power level - KEEPING for performance
echo 1260000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo 1260000000 > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo 1260000000 > /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq
echo 1260000000 > /sys/class/kgsl/kgsl-3d0/devfreq/target_freq
echo 0 > /sys/class/kgsl/kgsl-3d0/min_pwrlevel
echo 0 > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
echo 0 > /sys/class/kgsl/kgsl-3d0/default_pwrlevel
echo performance > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo 1260 > /sys/class/kgsl/kgsl-3d0/clock_mhz
echo 1260 > /sys/class/kgsl/kgsl-3d0/max_clock_mhz
echo 1260 > /sys/class/kgsl/kgsl-3d0/min_clock_mhz
echo 1260000000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk

# Moderate thermal limits (safer than complete disable)
echo 85 > /sys/class/thermal/thermal_zone0/trip_point_1_temp
echo 90 > /sys/class/thermal/thermal_zone0/trip_point_2_temp

# CPU & kernel boost settings - KEEPING
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/boost
echo 1 > /sys/module/cpu_boost/parameters/boost
echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled
echo 1 > /sys/module/cpu_boost/parameters/sched_boost
echo 1 > /sys/module/msm_performance/parameters/touchboost
echo 1 > /sys/module/msm_thermal/core_control/enabled

# EAS & power scheduling - KEEPING
echo 1 > /proc/sys/kernel/sched_boost
echo 0 > /sys/module/workqueue/parameters/power_efficient

# Kernel Tweaks - KEEPING
chmod 644 sys/kernel/fpscaps
echo 0 /sys/kernel/fpscaps
chmod 444 sys/kernel/fpscaps
chmod 644 /sys/kernel/gpu/gpu_clock
echo 1260 > /sys/kernel/gpu/gpu_clock
chmod 444 /sys/kernel/gpu/gpu_clock
chmod 644 /sys/kernel/gpu/gpu_min_clock
echo 1260 > /sys/kernel/gpu/gpu_min_clock
chmod 444 /sys/kernel/gpu/gpu_min_clock
chmod 644 /sys/kernel/gpu/gpu_max_clock
echo 1260 > /sys/kernel/gpu/gpu_max_clock
chmod 444 /sys/kernel/gpu/gpu_max_clock

# Ensure all cores online
for cpu in 0 1 2 3 4 5 6 7; do
    echo 1 > /sys/devices/system/cpu/cpu$cpu/online
done

cmd power set-fixed-performance-mode-enabled true
cmd power set-adaptive-power-saver-enabled false
cmd power set-mode 0

#done

sleep 15
