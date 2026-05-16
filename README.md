># Originally a fork of [Gaming-X-Magisk-Module](https://github.com/JordanTweaks/Gaming-X-Magisk-Module) by [JordanTweaks](https://github.com/JordanTweaks)
## *Gutted, Rewritten, and Optimized for Android Snapdragon devices like the Retroid Pocket 5*

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%2013%2B-green.svg)
![Device](https://img.shields.io/badge/Device-Retroid%20Pocket%205-orange.svg)
![Status](https://img.shields.io/badge/Status-Stable-success.svg)

### 📋 Complete Change Summary - Gaming-X Optimizer Module Overview
### Changes Made: Removed thermal throttling disable, forced FPS settings, Vulkan renderer locks, security-risk properties, and 25+ duplicate entries across files.

### **📁 File-by-File Changes**

**1. post-fs-data.sh**
   
|Status |	Changes |
| :---- | :------ |
|✅ | No Changes	File was already clean and minimal |

**2. service.sh**

|Category |	Action |	Details |
| :------ | :----- | :------- |
| CPU Performance |	✅ | KEPT	Small cores locked to 1.9 GHz, big cores to 2.8 GHz |
| GPU Performance |	✅ | KEPT	GPU locked to 1.26 GHz across all parameters | 
| Thermal Throttling |	❌ | REMOVED	throttling=0, force_bus_on, force_rail_on, force_clk_on, force_no_nap, pwrscale=0 |
| Thermal Override |	❌ | REMOVED	cmd thermalservice override-status 0 |
| FPS Forcing (Game) |	❌ | REMOVED	Entire game_overlay loop for all installed packages |
| FPS Forcing (Display) |	❌ | REMOVED	cmd display set-match-content-frame-rate-pref 1 |
| Duplicate Props |	❌ | REMOVED	All debug.sf.*, debug.hwui.*, debug.composition-type, persist.sys.composer entries (moved to system.prop.txt) |
| Boost Settings |	✅ | KEPT	CPU boost, sched_boost, touch_boost enabled |
| Kernel Tweaks |	✅ | KEPT	GPU clock, fpscaps settings preserved |

### `Lines Removed: ~45 lines (approximately 30% of file)`

**3. system.prop.txt**

|Category |	Action |	Details |
| :------ | :----- | :------- |
| RAM Optimization |	✅ | KEPT	ZRAM, bg_apps_limit, trim_enable_memory, purgeable_assets |
| Security Risks |	❌ | REMOVED	ro.kernel.android.checkjni=0, dalvik.vm.verify-bytecode=false, ENFORCE_PROCESS_LIMIT=false |
| GPU/Vulkan Locks |	❌ | REMOVED	debug.hwui.renderer=skiavk, debug.hwui.use_vulkan=true, ro.hwui.use_vulkan=true |
| Screen Tearing Risk |	❌ | REMOVED	debug.hwui.disable_vsync=true, vendor.debug.egl.swapinterval=0 |
| FPS Forcing |	❌ | REMOVED	All debug.cpurend.fps*, debug.sf.fps=120, ro.vendor.display.default_fps=120, persist.vendor.dfps.level=120 |
| Duplicates |	❌ | REMOVED	25+ duplicate entries that appeared in service.sh |
| Touch Optimization |	✅ | KEPT	All touch velocity, calibration, FIFO settings |
| Snapdragon Tweaks |	✅ | KEPT	debug.qctwa.* properties |
| 3D/Hardware Acceleration |	✅ | KEPT	hw3d.force=1, hw2d.force=1, video.accelerate.hw=1 |
| Phase Offsets |	❌ | REMOVED	All 8 debug.sf.*_phase_offset_ns entries (duplicates) |
| Game Turbo |	❌ | REMOVED	persist.sys.game.turbo=0 (conflicting with performance goals) |

### `Lines Removed: ~50 lines (approximately 40% of file)`

**4. uninstall.sh**

|Status |	Changes |
| :---- | :------ |
| ✅ | No Changes	File handles cleanup properly, no modifications needed |

**5. install.sh**

|Category |	Action |	Details |
| :------ | :----- | :------- |
| Replace Directive |	❌ | REMOVED	REPLACE="/vendor/etc/powerhint.xml" removed to preserve system behavior |
| Binary Permissions |	❌ | REMOVED	References to non-existent P0/P1 binaries removed |
| Installation Messages |	✏️ | SIMPLIFIED	Reduced verbose output, cleaner messages |

**6. powerhint.xml**

|Category |	Action |	Details |
| :------ | :----- | :------- |
| High FPS Game Mode |	✅ | KEPT	0x41424000 config for bengal, scuba, khaje targets |
| Camera Profiles |	❌ | REMOVED	All 0x00001331 through 0x00001336 entries (camera-specific, not gaming) |
| QVR Profiles |	❌ | REMOVED	All 0x0000130A through 0x00001312 entries (VR-specific, not gaming) |
| File Size |	📉 | REDUCED	~70% reduction in XML entries |

### 📊 Quantitative Summary

| Metric |	Before |	After |	Change |
| :----- | :------ | :----- | :----- |
| Total Lines Across All Files |	~650 |	~450 |	-31% |
| Duplicate Properties |	25+ |	0 |	-100%
| FPS-Forcing Commands |	15+ |	0 |	-100% |
| Thermal Disable Commands |	8 |	0 |	-100% |
| Security-Risk Properties |	3 |	0 |	-100% |
| Vulkan Renderer | Locks |	3 |	0 |	-100% |
| Camera/VR Configs |	20+ |	0 |	-100% |

### ⚠️ Risk Assessment Changes

| Risk Level |	Before |	After |	Impact |
| :--------- | :------ | :----- | :----- |
| Critical (Security) |	3 |	0 |	JNI/bytecode verification restored |
| High (Thermal) |	8 |	0 |	Thermal protection restored |
| Medium (Stability) |	5 |	0 |	VSync/screen tearing risks removed |
| Low (Conflicts) |	25+ |	0 |	All duplicates eliminated |

### ✅ Preserved Functionality

| Feature |	Status |	Notes |
| :------ | :----- | :----- |
| CPU Core Frequency Locks |	✅ | Active |	1.9 GHz (small), 2.8 GHz (big) |
| GPU Maximum Performance |	✅ | Active	1.26 GHz locked |
| ZRAM & Memory Optimization |	✅ | Active	All memory management props |
| CPU Boost Settings |	✅ | Active	sched_boost, touch_boost, etc. |
| Touch Response Optimization |	✅ | Active	Velocity, calibration settings |
| Hardware Acceleration	| ✅ | Active	EGL, HWUI, GPU driver flags |
| Snapdragon-Specific Tweaks |	✅ | Active	qctwa properties |
| Game Mode CPU/GPU Profiles |	✅ | Active	powerhint.xml 0x41424000 configs |

### 🔧 Conflicts Resolved

| Conflict Type |	Resolution |
| :------------ | :--------- |
|Duplicate Properties |	Consolidated to system.prop.txt as single source of truth |
| Vulkan vs Custom Drivers	| Removed all Vulkan forcing to allow driver flexibility |
| FPS Forcing vs Display Settings |	Removed all 120 FPS locks for native refresh rate support |
| Thermal Disable vs Safety |	Removed *most* thermal overrides for safer operation |
| Security vs Performance |	Restored JNI/bytecode verification for safety |

### 📝 To DO:

| Addition |	Purpose |	Risk Level | Completion |
| :------- | :------- | :--------- | :--------- |
| Moderate thermal limits |	Safer than complete disable |	Low | ✅ |
| Battery-aware mode |	Reduce drain when not gaming |	Low | Forgoing changes for better compatibility with AC Charging Controller until best workaround can be implemented |
