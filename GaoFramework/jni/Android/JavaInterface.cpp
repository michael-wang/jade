#include "AndroidApplication.h"
#include "JavaInterface.h"

static const char TAG[]                                = "native::framework::JavaInterface";
static const char METHOD_NAME_POP_TOUCH_EVENTS[]       = "popTouchEvents";
static const char METHOD_DESCRIPTOR_POP_TOUCH_EVENTS[] = "()[Lcom/studioirregular/gaoframework/TouchEvent;";

JavaInterface::JavaInterface() {

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();
	jobject obj = AndroidApplication::Singleton->GetJavaInterface();

	if (env != NULL && obj != NULL) {
		javaRef = env->NewGlobalRef(obj);
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "constructor invalid env:%p, obj:%p", env, obj);
		javaRef = NULL;
	}
}

JavaInterface::~JavaInterface() {
	if (javaRef != NULL) {
		JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

		if (env != NULL) {
			env->DeleteGlobalRef(javaRef);
			javaRef = NULL;
		}
	}
}

TouchEventArray* JavaInterface::GetTouchEvents() {

	TouchEventArray* result = new TouchEventArray();

	JNIEnv* env = AndroidApplication::Singleton->GetJniEnv();

	if (env == NULL) {
		// show error msg;
		return result;
	}

	jclass clazz = env->GetObjectClass(javaRef);

	jmethodID popTouchEvents = env->GetMethodID(clazz, METHOD_NAME_POP_TOUCH_EVENTS, 
		METHOD_DESCRIPTOR_POP_TOUCH_EVENTS);

	env->DeleteLocalRef(clazz);

	if (popTouchEvents == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"GetTouchEvents cannot find method ID for popTouchEvents.");
		return result;
	}

	jobjectArray jarr = (jobjectArray)env->CallObjectMethod(javaRef, popTouchEvents);

	const jsize SIZE = env->GetArrayLength(jarr);
	for (jsize i = 0; i < SIZE; i++) {
		jobject jevent = env->GetObjectArrayElement(jarr, i);

		TouchEvent* event = new TouchEvent(jevent);

		// delete local reference to prevent JNI local reference table overflow.
		env->DeleteLocalRef(jevent);

		result->Add(event);
	}

	return result;
}