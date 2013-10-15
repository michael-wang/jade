LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# IMPORTANT: change this to where your boost lives.
MY_BOOST_PATH := /Users/michael/Studio/sdk/boost_1_54_0

LOCAL_MODULE    := jadeninja
LOCAL_SRC_FILES := jadeninja.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../GaoFramework/jni
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../GaoFramework/jni/LuabindX/Lua/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../GaoFramework/jni/LuabindX/Luabind/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../GaoFramework/jni/LuabindX/Luabins/include
LOCAL_C_INCLUDES += $(MY_BOOST_PATH)

LOCAL_CPP_FEATURES := exceptions

LOCAL_LDLIBS    := -llog

LOCAL_SHARED_LIBRARIES := framework

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/../../GaoFramework/jni)
$(call import-module, Framework)