LOCAL_PATH      := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := png

LOCAL_SRC_FILES := png.c
LOCAL_SRC_FILES += pngerror.c
LOCAL_SRC_FILES += pngget.c
LOCAL_SRC_FILES += pngmem.c
LOCAL_SRC_FILES += pngpread.c
LOCAL_SRC_FILES += pngread.c
LOCAL_SRC_FILES += pngrio.c
LOCAL_SRC_FILES += pngrtran.c
LOCAL_SRC_FILES += pngrutil.c
LOCAL_SRC_FILES += pngset.c
LOCAL_SRC_FILES += pngtest.c
LOCAL_SRC_FILES += pngtrans.c
LOCAL_SRC_FILES += pngwio.c
LOCAL_SRC_FILES += pngwrite.c
LOCAL_SRC_FILES += pngwtran.c
LOCAL_SRC_FILES += pngwutil.c

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

LOCAL_EXPORT_LDLIBS := -lz

include $(BUILD_STATIC_LIBRARY)