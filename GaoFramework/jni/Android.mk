LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# IMPORTANT: change this to where your boost lives.
MY_BOOST_PATH := /Users/michael/Studio/sdk/boost_1_54_0

LOCAL_MODULE    := gaoframework

LOCAL_SRC_FILES := gaoframework.cpp
LOCAL_SRC_FILES += Android/AndroidGraphicsRenderer.cpp
LOCAL_SRC_FILES += Android/AndroidApplication.cpp
LOCAL_SRC_FILES += Android/AndroidAudioRenderer.cpp
LOCAL_SRC_FILES += Android/AndroidAudioResource.cpp
LOCAL_SRC_FILES += Android/AndroidLogger.cpp
LOCAL_SRC_FILES += Android/GLTexture.cpp
LOCAL_SRC_FILES += Android/JavaInterface.cpp
LOCAL_SRC_FILES += Android/JniHelper.cpp
LOCAL_SRC_FILES += Android/Rectangle.cpp
LOCAL_SRC_FILES += Android/Resource.cpp
LOCAL_SRC_FILES += Android/TouchEvent.cpp

LOCAL_C_INCLUDES += $(MY_BOOST_PATH)

LOCAL_CPP_FEATURES := exceptions

LOCAL_STATIC_LIBRARIES := framework png

LOCAL_LDLIBS    := -llog -landroid

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH))
$(call import-module, Framework)
$(call import-module, libpng-1.6.6)