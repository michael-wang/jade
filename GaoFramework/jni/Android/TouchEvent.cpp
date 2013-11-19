#include "TouchEvent.h"
#include "Java/JniEnv.h"
#include <android/log.h>


static const char TAG[] = "native::framework::TouchEvent";

TouchEvent::TouchEvent(jobject obj) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Constructor");

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "TouchEvent env == NULL");
		return;
	}

	jclass clazz = env->GetObjectClass(obj);

	jfieldID fid = env->GetFieldID(clazz, "x", "F");
	x = env->GetFloatField(obj, fid);

	fid = env->GetFieldID(clazz, "y", "F");
	y = env->GetFloatField(obj, fid);

	fid = env->GetFieldID(clazz, "action", "I");
	action = env->GetIntField(obj, fid);
}

TouchEvent::~TouchEvent() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Destructor");
}