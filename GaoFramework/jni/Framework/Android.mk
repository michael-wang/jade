LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# IMPORTANT: change this to where your boost lives.
MY_BOOST_PATH := /Users/michael/Studio/sdk/boost_1_54_0

LOCAL_MODULE    := framework

LOCAL_CPP_FEATURES := exceptions

LOCAL_SRC_FILES := Application.cpp
LOCAL_SRC_FILES += AudioEngine.cpp
LOCAL_SRC_FILES += AudioRenderer.cpp
LOCAL_SRC_FILES += AudioResource.cpp
LOCAL_SRC_FILES += FileSystem.cpp
LOCAL_SRC_FILES += GraphicsEngine.cpp
LOCAL_SRC_FILES += GraphicsRenderer.cpp
LOCAL_SRC_FILES += InputSystem.cpp
LOCAL_SRC_FILES += Logger.cpp
LOCAL_SRC_FILES += LuaFunction.cpp
LOCAL_SRC_FILES += LuaFunctionGraphics.cpp
LOCAL_SRC_FILES += LuaScriptManager.cpp
LOCAL_SRC_FILES += Sprite.cpp
LOCAL_SRC_FILES += Texture.cpp
LOCAL_SRC_FILES += Timer.cpp
LOCAL_SRC_FILES += Transform.cpp
LOCAL_SRC_FILES += Vector2D.cpp
LOCAL_SRC_FILES += Window.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../LuabindX/Lua/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../LuabindX/Luabind/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../LuabindX/Luabins/include
LOCAL_C_INCLUDES += $(MY_BOOST_PATH)

LOCAL_SHARED_LIBRARIES := luajit luabind luabins

include $(BUILD_STATIC_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/../)

# $(call import-module, LuabindX/Lua)
$(call import-module, LuabindX/LuaJIT)
$(call import-module, LuabindX/Luabind)
$(call import-module, LuabindX/Luabins)
