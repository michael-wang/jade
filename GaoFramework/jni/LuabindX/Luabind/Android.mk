LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# IMPORTANT: change this to where your boost lives.
MY_BOOST_PATH := /Users/michael/Studio/sdk/boost_1_54_0

LOCAL_MODULE    := luabind

LOCAL_SRC_FILES := src/class.cpp
LOCAL_SRC_FILES += src/link_compatibility.cpp
LOCAL_SRC_FILES += src/class_info.cpp
LOCAL_SRC_FILES += src/object_rep.cpp
LOCAL_SRC_FILES += src/class_registry.cpp
LOCAL_SRC_FILES += src/open.cpp
LOCAL_SRC_FILES += src/class_rep.cpp
LOCAL_SRC_FILES += src/pcall.cpp
LOCAL_SRC_FILES += src/create_class.cpp
LOCAL_SRC_FILES += src/scope.cpp
LOCAL_SRC_FILES += src/error.cpp
LOCAL_SRC_FILES += src/stack_content_by_name.cpp
LOCAL_SRC_FILES += src/exception_handler.cpp
LOCAL_SRC_FILES += src/weak_ref.cpp
LOCAL_SRC_FILES += src/function.cpp
LOCAL_SRC_FILES += src/wrapper_base.cpp
LOCAL_SRC_FILES += src/inheritance.cpp

LOCAL_C_INCLUDES += $(LOCAL_PATH)/include
LOCAL_C_INCLUDES += $(MY_BOOST_PATH)

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)/include

LOCAL_CPP_FEATURES := exceptions

LOCAL_SHARED_LIBRARIES := lua

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/../)
$(call import-module, LuabindX/Lua)