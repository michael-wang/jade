LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := gaoframework
LOCAL_SRC_FILES := gaoframework.cpp

LOCAL_SHARED_LIBRARIES := lua

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH))
$(call import-module, LuabindX/Lua)