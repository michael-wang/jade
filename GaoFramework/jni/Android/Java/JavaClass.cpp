#include "JavaClass.h"
#include "JniEnv.h"
#include <stdarg.h>


const char* JavaClass::CONSTRUCTOR_METHOD_NAME = "<init>";

JavaClass::JavaClass(const char* path) :
	CLASS_PATH (path),
	log ("native::framework::JavaClass", false) {
	
	LOGD(log, "%s[%p]: path:%s", __func__, this, path)

	JNIEnv* env = g_JniEnv->Get();

	if (env != NULL) {
		jclass clazz = env->FindClass(path);

		if (clazz != NULL) {
			classRef = (jclass)env->NewGlobalRef(clazz);
		} else {
			LOGE(log, "%s[%p]: cannot FindClass: %s", __func__, this, path)
		}
	} else {
		LOGE(log, "%s[%p]:: cannot find JNIEnv*", __func__, this)
	}
}

JavaClass::~JavaClass() {

	LOGW(log, "%s[%p]: for class:%s", __func__, this, CLASS_PATH.c_str())

	if (classRef != NULL) {
		JNIEnv* env = g_JniEnv->Get();

		if (env != NULL) {
			env->DeleteGlobalRef(classRef);
			classRef = NULL;
		}
	}
}

jmethodID JavaClass::GetMethodID(const char* name, const char* descriptor) {

	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (classRef == NULL) {
		LOGE(log, "%s[%p]: invalid classRef: NULL.", __func__, this)
	}

	JNIEnv* env = g_JniEnv->Get();
	if (env == NULL) {
		return NULL;
	}

	return env->GetMethodID(classRef, name, descriptor);
}

jobject JavaClass::CallStaticObjectMethod(const char* name, const char* descriptor, ...) {

	LOGD(log, "%s[%p]: name:%s, descriptor:%s", __func__, this, name, descriptor)

	if (classRef == NULL) {
		LOGE(log, "%s[%p]: invalid classRef: NULL.", __func__, this)
	}

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

