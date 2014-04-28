#ifndef JNIENV_H_
#define JNIENV_H_

#include <jni.h>
#include <Framework/Singleton.hpp>
#include <Android/AndroidLogger.h>
#include "JavaClass.h"
#include <map>
#include <string>
#include <stdarg.h>


#define g_JniEnv JniEnv::GetSingletonPointer()

class JniEnv : public Gao::Framework::Singleton<JniEnv> {

public:
	JniEnv() : 
		env (NULL), 
		log ("JniEnv", FALSE) {
		
		LOGD(log, "Constructor")
	}

	virtual ~JniEnv() {

		LOGD(log, "Destructor")

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

	void DeleteLocalRef(jobject obj) {
		if (env != NULL) {
			env->DeleteLocalRef(obj);
		}
	}

	jstring NewStringUTF(const char* str) {
		if (env == NULL) {
			return NULL;
		}

		return env->NewStringUTF(str);
	}

	const char* GetStringUTFChars(jstring jstr, jboolean* isCopy) {
		if (env == NULL) {
			return NULL;
		}

		return env->GetStringUTFChars(jstr, isCopy);
	}

	void ReleaseStringUTFChars(jstring jstr, const char* chars) {
		if (env == NULL) {
			return;
		}

		return env->ReleaseStringUTFChars(jstr, chars);
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

	jfloat CallFloatMethod(jobject obj, jmethodID method, va_list args) {

		if (env == NULL) {
			return NULL;
		}

		return env->CallFloatMethodV(obj, method, args);
	}

private:
	// class path maps to java class pointer.
	typedef std::map<std::string, JavaClass*> ClassMap;
	typedef std::pair<std::string, JavaClass*> ClassMapItem;

	JNIEnv* env;
	ClassMap classMap;
	AndroidLogger log;
};

#endif /* JNIENV_H_ */