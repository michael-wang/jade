LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := luabins

LOCAL_SRC_FILES := src/fwrite.c
LOCAL_SRC_FILES += src/load.c
LOCAL_SRC_FILES += src/luabins.c
LOCAL_SRC_FILES += src/luainternals.c
LOCAL_SRC_FILES += src/lualess.c
LOCAL_SRC_FILES += src/save.c
LOCAL_SRC_FILES += src/savebuffer.c
LOCAL_SRC_FILES += src/write.c

LOCAL_C_INCLUDES += $(LOCAL_PATH)/include

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)/include

LOCAL_SHARED_LIBRARIES := lua

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/../)
$(call import-module, LuabindX/Lua)