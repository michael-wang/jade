#ifndef JNIENV_H_
#define JNIENV_H_

#include <jni.h>
#include <Framework/Singleton.hpp>
#include <map>
#include <string>
#include "JavaClass.h"
#include <stdarg.h>
#include <android/log.h>


#define g_JniEnv JniEnv::GetSingletonPointer()

class JniEnv : public Gao::Framework::Singleton<JniEnv> {

public:
	JniEnv() {
		env = NULL;
	}

	virtual ~JniEnv() {

		__android_log_print(ANDROID_LOG_DEBUG, "JniEnv", "~JniEnv");

		for (ClassMap::iterator i = classMap.begin(); i != classMap.end(); ++i) {
			if (i->second != NULL) {
				delete i->second;
			}
		}
		classMap.clear();
	}

	void Set(JNIEnv* e) {
		env = e;
	}

	JNIEnv* Get() {
		return env;
	}

	JavaClass* FindClass(const char* _path) {

		const std::string path (_path);

		ClassMap::iterator existed = classMap.find(path);
		if (existed != classMap.end()) {
			return existed->second;
		}

		JavaClass* clazz = new JavaClass(_path);

		classMap.insert(ClassMapItem(path, clazz));

		return clazz;
	}

	jobject NewObject(JavaClass* clazz, jmethodID method, va_list args) {

		if (env == NULL) {
			return NULL;
		}

		return  env->NewObjectV(clazz->GetClassRef(), method, args);
	}

	jobject NewGlobalRef(jobject obj) {
		if (env == NULL) {
			return NULL;
		}

		return env->NewGlobalRef(obj);
	}

	void DeleteGlobalRef(jobject obj) {
		if (env != NULL) {
			env->DeleteGlobalRef(obj);
		}
	}

	jstring NewStringUTF(const char* str) {
		if (env == NULL) {
			return NULL;
		}

		return env->NewStringUTF(str);
	}

	void CallVoidMethod(jobject obj, jmethodID method, va_list args) {

		if (env == NULL) {
			return;
		}

		env->CallVoidMethodV(obj, method, args);
	}

	bool CallBooleanMethod(jobject obj, jmethodID method, va_list args) {

		if (env == NULL) {
			return false;
		}

		return env->CallBooleanMethodV(obj, method, args);
	}

	jobject CallObjectMethod(jobject obj, jmethodID method, va_list args) {

		if (env == NULL) {
			return NULL;
		}

		return env->CallObjectMethodV(obj, method, args);
	}

private:
	// class path maps to java class pointer.
	typedef std::map<std::string, JavaClass*> ClassMap;
	typedef std::pair<std::string, JavaClass*> ClassMapItem;

	JNIEnv* env;
	ClassMap classMap;
};

#endif /* JNIENV_H_ */