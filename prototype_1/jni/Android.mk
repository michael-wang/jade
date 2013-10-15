LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := jadeninja
LOCAL_SRC_FILES := jadeninja.cpp

include $(BUILD_SHARED_LIBRARY)
