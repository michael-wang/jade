#include "JniHelper.h"
#include <android/log.h>
#include <stdarg.h>


static const char TAG[] = "native::framework::JniHelper";

JniHelper::JniHelper(const char* classPath) :
	JAVA_CLASS_PATH (classPath) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "JniHelper: classPath:%s", classPath);
}

JniHelper::~JniHelper() {
	for (MethodMap::iterator itr = methods.begin(); itr != methods.end(); ++itr) {
		delete itr->second;
	}
	methods.clear();
}

jobject JniHelper::NewObject(JNIEnv* env, const char* ctorDescriptor, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"NewObject: for class:%s and constructor:%s", JAVA_CLASS_PATH.c_str(), 
		ctorDescriptor);

	if (env == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "NewObject: invalid JNIEnv:%p", env);
		return NULL;
	}

	jclass clazz = env->FindClass(JAVA_CLASS_PATH.c_str());
	if (clazz == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"NewObject: cannot find class for path:%s", JAVA_CLASS_PATH.c_str());
		return NULL;
	}

	jmethodID ctor = env->GetMethodID(clazz, "<init>", ctorDescriptor);
	if (ctor == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"NewObject cannot find constructor with descriptor:%s", ctorDescriptor);
		return NULL;
	}

	va_list args;
	va_start(args, ctorDescriptor);
	jobject result = env->NewObjectV(clazz, ctor, args);
	va_end(args);

	return result;
}

bool JniHelper::AddMethod(JNIEnv* env, int id, const char* name, 
	const char* descriptor) {

	if (env == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "AddMethod: invalid JNIEnv:%p", env);
		return false;
	}

	if (methods.find(id) != methods.end()) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "AddMethod: id(%d) existed", id);
		return false;
	}

	jclass clazz = env->FindClass(JAVA_CLASS_PATH.c_str());
	if (clazz == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"AddMethod: cannot find class for path:%s", JAVA_CLASS_PATH.c_str());
		return false;
	}

	jmethodID jid = env->GetMethodID(clazz, name, descriptor);
	if (jid == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"AddMethod: cannot find method with name:%s and descriptor:%s", name, 
			descriptor);
		return false;
	}

	JMethod* method = new JMethod(id, name, descriptor, jid);
	methods.insert(std::pair<int, JMethod*>(id, method));
	return true;
}

jmethodID JniHelper::GetMethod(int id) {

	MethodMap::iterator method = methods.find(id);
	if (method != methods.end()) {
		return method->second->jid;
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"GetMethod: cannot find method with id:%d.", id);
	}
	return NULL;
}