#include "JavaObject.h"
#include "JniEnv.h"
#include <android/log.h>
#include <stdarg.h>


static const char TAG[] = "native::framework::JavaObject";

JavaObject::JavaObject(const char* classPath, const char* constructor, ...) :
	clazz (g_JniEnv->FindClass(classPath)),
	javaRef (NULL) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"JavaObject classPath:%s, constructor:%s", classPath, constructor);

	jmethodID ctor = NULL;
	if (clazz != NULL) {
		ctor = clazz->GetMethodID(JavaClass::CONSTRUCTOR_METHOD_NAME, constructor);
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"JavaObject cannot find class: %s", classPath);
	}

	if (ctor != NULL) {
		va_list args;
		va_start(args, constructor);
		jobject obj = g_JniEnv->NewObject(clazz, ctor, args);
		va_end(args);

		SetJavaRef(obj);
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"JavaObject cannot find constructor with name:%s, descriptor:%s", 
			JavaClass::CONSTRUCTOR_METHOD_NAME, constructor);
	}
}

JavaObject::JavaObject(const char* classPath) :
	clazz (g_JniEnv->FindClass(classPath)),
	javaRef (NULL) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "JavaObject classPath:%s", classPath);
}

JavaObject::~JavaObject() {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "~JavaObject path:%s", 
		clazz->GetClassPath().c_str());

	SetJavaRef(NULL);
}

void JavaObject::SetJavaRef(jobject ref) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "SetJavaRef: ref:%p, old ref:%p", 
		ref, javaRef);

	if (javaRef != NULL) {
		g_JniEnv->DeleteGlobalRef(javaRef);
	}

	if (ref != NULL) {
		javaRef = g_JniEnv->NewGlobalRef(ref);
	} else {
		javaRef = NULL;
	}
}

void JavaObject::CallVoidMethod(const char* name, const char* descriptor, ...) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "CallVoidMethod name:%s, descriptor:%s", 
		name, descriptor);

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CallVoidMethod cannot find method with name:%s, descriptor:%s", 
			name, descriptor);
	}

	va_list args;
	va_start(args, descriptor);
	g_JniEnv->CallVoidMethod(javaRef, method, args);
	va_end(args);
}

bool JavaObject::CallBooleanMethod(const char* name, const char* descriptor, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"CallBooleanMethod name:%s, descriptor:%s", name, descriptor);

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CallBooleanMethod cannot find method with name:%s, descriptor:%s", 
			name, descriptor);
		return false;
	}

	va_list args;
	va_start(args, descriptor);
	bool result = g_JniEnv->CallBooleanMethod(javaRef, method, args);
	va_end(args);

	return result;
}

jobject JavaObject::CallObjectMethod(const char* name, const char* descriptor, ...) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"CallObjectMethod name:%s, descriptor:%s", name, descriptor);

	jmethodID method = clazz->GetMethodID(name, descriptor);
	if (method == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CallObjectMethod cannot find method with name:%s, descriptor:%s", 
			name, descriptor);
		return NULL;
	}

	va_list args;
	va_start(args, descriptor);
	jobject result = g_JniEnv->CallObjectMethod(javaRef, method, args);
	va_end(args);

	return result;
}
