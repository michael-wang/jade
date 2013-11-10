#include "JavaObject.h"
#include "JniEnv.h"
#include <android/log.h>
#include <stdarg.h>


static const char TAG[] = "native::framework::JavaObject";

JavaObject::JavaObject(const char* classPath, const char* constructor, ...) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "JavaObject");

	clazz = g_JniEnv->FindClass(classPath);

	jmethodID ctor = clazz->GetMethodID(JavaClass::CONSTRUCTOR_METHOD_NAME, constructor);

	if (ctor != NULL) {
		va_list args;
		va_start(args, constructor);
		jobject obj = g_JniEnv->NewObject(clazz, ctor, args);
		va_end(args);

		javaRef = g_JniEnv->NewGlobalRef(obj);
	}
}

JavaObject::~JavaObject() {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "~JavaObject");

	if (javaRef != NULL) {
		g_JniEnv->DeleteGlobalRef(javaRef);
		javaRef = NULL;
	}
}

void JavaObject::CallVoidMethod(const char* name, const char* descriptor, ...) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "CallVoidMethod name:%s, descriptor:%s", 
		name, descriptor);

	jmethodID method = clazz->GetMethodID(name, descriptor);

	va_list args;
	va_start(args, descriptor);
	g_JniEnv->CallVoidMethod(javaRef, method, args);
	va_end(args);
}

bool JavaObject::CallBooleanMethod(const char* name, const char* descriptor, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"CallBooleanMethod name:%s, descriptor:%s", name, descriptor);

	jmethodID method = clazz->GetMethodID(name, descriptor);

	va_list args;
	va_start(args, descriptor);
	bool result = g_JniEnv->CallBooleanMethod(javaRef, method, args);
	va_end(args);

	return result;
}
