LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# IMPORTANT: change this to where your boost lives.
MY_BOOST_PATH := /Users/michael/Studio/sdk/boost_1_54_0

LOCAL_MODULE    := gaoframework

LOCAL_SRC_FILES := gaoframework.cpp
LOCAL_SRC_FILES += Android/AndroidGraphicsRenderer.cpp
LOCAL_SRC_FILES += Android/AndroidApplication.cpp
LOCAL_SRC_FILES += Android/AndroidLogger.cpp

LOCAL_C_INCLUDES += $(MY_BOOST_PATH)

LOCAL_CPP_FEATURES := exceptions

LOCAL_STATIC_LIBRARIES := framework

LOCAL_LDLIBS    := -llog

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH))
$(call import-module, Framework)