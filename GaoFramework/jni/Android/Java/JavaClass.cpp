#include "JavaClass.h"
#include "JniEnv.h"
#include <stdarg.h>


const char* JavaClass::CONSTRUCTOR_METHOD_NAME = "<init>";

JavaClass::JavaClass(const char* path) :
	CLASS_PATH (path),
	log ("native::framework::JavaClass", false) {
	
	LOGD(log, "Constructor: for class path:%s", path)

	JNIEnv* env = g_JniEnv->Get();

	if (env != NULL) {
		jclass clazz = env->FindClass(path);

		if (clazz != NULL) {
			classRef = (jclass)env->NewGlobalRef(clazz);
		} else {
			LOGE(log, "Constructor: cannot FindClass: %s", path)
		}
	} else {
		LOGE(log, "Constructor: cannot find JNIEnv*")
	}
}

JavaClass::~JavaClass() {

	LOGD(log, "Destructor: for class path:%s", CLASS_PATH.c_str())

	if (classRef != NULL) {
		JNIEnv* env = g_JniEnv->Get();

		if (env != NULL) {
			env->DeleteGlobalRef(classRef);
			classRef = NULL;
		}
	}
}

jmethodID JavaClass::GetMethodID(const char* name, const char* descriptor) {

	LOGD(log, "GetMethodID: name:%s, descriptor:%s", name, descriptor)

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		return NULL;
	}

	return env->GetMethodID(classRef, name, descriptor);
}

jobject JavaClass::CallStaticObjectMethod(const char* name, const char* descriptor, ...) {

	LOGD(log, "CallStaticObjectMethod: name:%s, descriptor:%s", name, descriptor)

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		LOGE(log, "CallStaticObjectMethod: cannot find JNIEnv*")
		return NULL;
	}

	jmethodID method = env->GetStaticMethodID(classRef, name, descriptor);
	if (method == NULL) {
		LOGD(log, 
			"CallStaticObjectMethod: cannot find method with name:%s, descriptor:%s", 
			name, descriptor)
		return NULL;
	}

	va_list args;
	va_start(args, descriptor);
	jobject result = env->CallStaticObjectMethodV(classRef, method, args);
	va_end(args);

	return result;
}

