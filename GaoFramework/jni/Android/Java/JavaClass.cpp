#include "JavaClass.h"
#include <android/log.h>
#include "JniEnv.h"


static const char TAG[] = "native::framework::JavaClass";

const char* JavaClass::CONSTRUCTOR_METHOD_NAME = "<init>";

JavaClass::JavaClass(const char* path) :
	CLASS_PATH (path) {
	
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Constructor: for class path:%s", path);

	JNIEnv* env = g_JniEnv->Get();

	if (env != NULL) {
		jclass classObject = env->FindClass(path);

		if (classObject != NULL) {
			classRef = (jclass)env->NewGlobalRef(classObject);
		}
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