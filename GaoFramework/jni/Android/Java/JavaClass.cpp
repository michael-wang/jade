#include "JavaClass.h"
#include "JniEnv.h"
#include <android/log.h>
#include <stdarg.h>


static const char TAG[] = "native::framework::JavaClass";

const char* JavaClass::CONSTRUCTOR_METHOD_NAME = "<init>";

JavaClass::JavaClass(const char* path) :
	CLASS_PATH (path) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Constructor: for class path:%s", path);

	JNIEnv* env = g_JniEnv->Get();

	if (env != NULL) {
		jclass clazz = env->FindClass(path);

		if (clazz != NULL) {
			classRef = (jclass)env->NewGlobalRef(clazz);
		} else {
			__android_log_print(ANDROID_LOG_ERROR, TAG, 
				"Constructor: cannot FindClass: %s", path);
		}
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "Constructor: cannot find JNIEnv*");
	}
}

JavaClass::~JavaClass() {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Destructor: for class path:%s", 
		CLASS_PATH.c_str());

	if (classRef != NULL) {
		JNIEnv* env = g_JniEnv->Get();

		if (env != NULL) {
			env->DeleteGlobalRef(classRef);
			classRef = NULL;
		}
	}
}

jmethodID JavaClass::GetMethodID(const char* name, const char* descriptor) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "GetMethodID: name:%s, descriptor:%s", 
		name, descriptor);

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		return NULL;
	}

	return env->GetMethodID(classRef, name, descriptor);
}

jobject JavaClass::CallStaticObjectMethod(const char* name, const char* descriptor, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"CallStaticObjectMethod: name:%s, descriptor:%s", name, descriptor);

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CallStaticObjectMethod: cannot find JNIEnv*");
		return NULL;
	}

	jmethodID method = env->GetStaticMethodID(classRef, name, descriptor);
	if (method == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"CallStaticObjectMethod: cannot find method with name:%s, descriptor:%s", 
			name, descriptor);
		return NULL;
	}

	va_list args;
	va_start(args, descriptor);
	jobject result = env->CallStaticObjectMethodV(classRef, method, args);
	va_end(args);

	return result;
}

