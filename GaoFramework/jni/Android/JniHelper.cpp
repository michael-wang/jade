#include "JniHelper.h"
#include <Android/AndroidApplication.h>

#include <android/log.h>
#include <stdarg.h>


static const char TAG[] = "native::framework::JniHelper";

static const char CONSTRUCTOR_NAME[] = "<init>";

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

jobject JniHelper::NewObject(const char* ctorDescriptor, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: NewObject: constructor:%s", 
		JAVA_CLASS_PATH.c_str(), ctorDescriptor);

	JNIEnv* env = GetJniEnv("NewObject");
	if (env == NULL) {
		return NULL;
	}

	jclass clazz = env->FindClass(JAVA_CLASS_PATH.c_str());
	if (clazz == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: NewObject: cannot find java class.", JAVA_CLASS_PATH.c_str());
		return NULL;
	}

	jmethodID ctor = env->GetMethodID(clazz, CONSTRUCTOR_NAME, ctorDescriptor);
	if (ctor == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: NewObject: cannot find constructor with descriptor:%s", 
			JAVA_CLASS_PATH.c_str(), ctorDescriptor);
		return NULL;
	}

	va_list args;
	va_start(args, ctorDescriptor);
	jobject result = env->NewObjectV(clazz, ctor, args);
	va_end(args);

	return result;
}

jobject JniHelper::NewGlobalRef(jobject obj) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: NewGlobalRef", 
		JAVA_CLASS_PATH.c_str());

	JNIEnv* env = GetJniEnv("NewGlobalRef");
	if (env == NULL) {
		return NULL;
	}

	return env->NewGlobalRef(obj);
}

void JniHelper::DeleteGlobalRef(jobject obj) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: DeleteGlobalRef", 
		JAVA_CLASS_PATH.c_str());

	JNIEnv* env = GetJniEnv("DeleteGlobalRef");
	if (env == NULL) {
		return;
	}

	env->DeleteGlobalRef(obj);
}

bool JniHelper::CacheMethod(int id, const char* name, const char* descriptor) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, 
		"%s: CacheMethod: name:%s, descriptor:%s", JAVA_CLASS_PATH.c_str(), name, 
		descriptor);

	JNIEnv* env = GetJniEnv("CacheMethod");
	if (env == NULL) {
		return false;
	}

	if (methods.find(id) != methods.end()) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, "%s: AddMethod: id(%d) existed", 
			JAVA_CLASS_PATH.c_str(), id);
		return false;
	}

	jclass clazz = env->FindClass(JAVA_CLASS_PATH.c_str());
	if (clazz == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: AddMethod: cannot find Java class.", JAVA_CLASS_PATH.c_str());
		return false;
	}

	jmethodID jid = env->GetMethodID(clazz, name, descriptor);
	if (jid == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: AddMethod: cannot find method with name:%s and descriptor:%s", 
			JAVA_CLASS_PATH.c_str(), name, descriptor);
		return false;
	}

	JMethod* method = new JMethod(id, jid);
	methods.insert(std::pair<int, JMethod*>(id, method));
	return true;
}

void JniHelper::CallVoidMethod(jobject obj, int id, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: CallVoidMethod: id:%d", 
		JAVA_CLASS_PATH.c_str(), id);

	JNIEnv* env = GetJniEnv("CallVoidMethod");
	if (env == NULL) {
		return;
	}

	jmethodID jid = GetMethod("CallVoidMethod", id);

	if (jid == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: CallBooleanMethod: cannot find method with id:%d.", 
			JAVA_CLASS_PATH.c_str(), id);
		return;
	}

	va_list args;
	va_start(args, id);
	env->CallVoidMethodV(obj, jid, args);
	va_end(args);
}

jboolean JniHelper::CallBooleanMethod(jobject obj, int id, ...) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: CallBooleanMethod: id:%d", 
		JAVA_CLASS_PATH.c_str(), id);

	JNIEnv* env = GetJniEnv("CallBooleanMethod");
	if (env == NULL) {
		return false;
	}

	jmethodID jid = GetMethod("CallBooleanMethod", id);

	if (jid == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: CallBooleanMethod: cannot find method with id:%d.", 
			JAVA_CLASS_PATH.c_str(), id);
		return false;
	}

	va_list args;
	va_start(args, id);
	jboolean result = env->CallBooleanMethodV(obj, jid, args);
	va_end(args);

	return result;
}

jstring JniHelper::NewStringUTF(const char* str) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "%s: NewStringUTF: str:%s", 
		JAVA_CLASS_PATH.c_str(), str);

	JNIEnv* env = GetJniEnv("NewStringUTF");
	if (env == NULL) {
		return NULL;
	}

	return env->NewStringUTF(str);
}

JNIEnv* JniHelper::GetJniEnv(const char* caller) {

	if (AndroidApplication::Singleton == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: %s: GetJniEnv: AndroidApplication::Singleton == NULL", 
			JAVA_CLASS_PATH.c_str(), caller);
		return NULL;
	}

	JNIEnv* result = AndroidApplication::Singleton->GetJniEnv();
	if (result == NULL) {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: %s: GetJniEnv: AndroidApplication returns NULL env", 
			JAVA_CLASS_PATH.c_str(), caller);
	}

	return result;
}

jmethodID JniHelper::GetMethod(const char* caller, int id) {

	MethodMap::iterator method = methods.find(id);
	if (method != methods.end()) {
		return method->second->jid;
	} else {
		__android_log_print(ANDROID_LOG_ERROR, TAG, 
			"%s: GetMethod: cannot find method with id:%d, caller:%s", 
			JAVA_CLASS_PATH.c_str(), id, caller);
	}
	return NULL;
}