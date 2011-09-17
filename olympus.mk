#
# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This is the product configuration for a generic GSM olympus,
# not specialized for any geography.
#

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

## (1) First, the most specific values, i.e. the aspects that are specific to GSM
PRODUCT_COPY_FILES += \
    device/motorola/olympus/init.olympus.rc:root/init.olympus.rc \
    device/motorola/olympus/ueventd.olympus.rc:root/ueventd.olympus.rc

# motorola helper scripts
PRODUCT_COPY_FILES += \
    device/motorola/olympus/scripts/pds_perm_fix.sh:system/bin/pds_perm_fix.sh \
    device/motorola/olympus/scripts/bt_init_wrapper.sh:system/bin/bt_init_wrapper.sh \
    device/motorola/olympus/scripts/hciattach_wrapper.sh:system/bin/hciattach_wrapper.sh

# sysctl conf
PRODUCT_COPY_FILES += \
    device/motorola/olympus/config/sysctl.conf:system/etc/sysctl.conf

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# olympus uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# copy all kernel modules under the "modules" directory to system/lib/modules
PRODUCT_COPY_FILES += $(shell \
    find device/motorola/olympus/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/motorola/olympus/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

PRODUCT_PACKAGES += Usb \
    Superuser \
    su

# Engineering utilities
PRODUCT_PACKAGES += \
    Development \
    SpareParts \
    Term

DEVICE_PACKAGE_OVERLAYS += device/motorola/olympus/overlay

# Board-specific init
PRODUCT_COPY_FILES += \
    device/motorola/olympus/config/vold.fstab:system/etc/vold.fstab \
    device/motorola/olympus/init.vsnet:system/bin/init.vsnet \
    device/motorola/olympus/scripts/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh \
    device/motorola/olympus/config/media_profiles.xml:system/etc/media_profiles.xml \
    device/motorola/olympus/config/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

#keyboard files
PRODUCT_COPY_FILES += \
    device/motorola/olympus/keylayout/tegra-kbc.kl:system/usr/keylayout/tegra-kbc.kl \
    device/motorola/olympus/keychars/tegra-kbc.kcm.bin:system/usr/keychars/tegra-kbc.kcm.bin \
    device/motorola/olympus/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    device/motorola/olympus/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/motorola/olympus/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl:system/usr/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl \
    device/motorola/olympus/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    device/motorola/olympus/keylayout/evfwd.kl:system/usr/keylayout/evfwd.kl \
    device/motorola/olympus/keychars/evfwd.kcm.bin:system/usr/keychars/evfwd.kcm.bin \
    device/motorola/olympus/keylayout/usb_keyboard_102_en_us.kl:system/usr/keylayout/usb_keyboard_102_en_us.kl \
    device/motorola/olympus/keychars/usb_keyboard_102_en_us.kcm.bin:system/usr/keychars/usb_keyboard_102_en_us.kcm.bin

# Permission files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

# Bring in apns from CM
PRODUCT_COPY_FILES += \
    device/motorola/olympus/apns-conf.xml:system/etc/apns-conf.xml


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

## (2) Also get non-open-source CDMA-specific aspects if available
$(call inherit-product-if-exists, vendor/motorola/olympus/olympus-vendor.mk)

$(call inherit-product, build/target/product/full.mk)

PRODUCT_NAME := generic_olympus
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := olympus
PRODUCT_MODEL := MB860
PRODUCT_MANUFACTURER := Motorola
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_FINGERPRINT=MOTO/olyatt/olympus:2.3.4/4.5.91/110625:user/release-keys PRIVATE_BUILD_DESC="olympus-user 2.3.4 4.5.91 110625 release-keys"
PRODUCT_SPECIFIC_DEFINES = WEBCORE_ACCELERATED_SCROLLING=true

