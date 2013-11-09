#ifndef JNIHELPER_H_
#define JNIHELPER_H_

#include <jni.h>
#include <map>
#include <string>

/*
 * Designed to be use as: one C++ class with one JniHelper instance.
 *
 * Notice: *NOT* thread safe.
 */
class JniHelper {

public:
	JniHelper(const char* classPath);
	virtual ~JniHelper();

	JNIEnv* GetJniEnv(const char* caller);

	bool CacheMethod(int id, const char* name, const char* descriptor);

	jobject NewObject(const char* ctorDescriptor, ...);
	jobject NewGlobalRef(jobject obj);
	void    DeleteGlobalRef(jobject obj);

	void     CallVoidMethod(jobject obj, int id, ...);
	jboolean CallBooleanMethod(jobject obj, int id, ...);

	jstring NewStringUTF(const char* str);

private:
	jmethodID GetMethod(const char* caller, int id);

private:
	struct JMethod {
		int id;
		jmethodID jid;

		JMethod(int userDefinedId, jmethodID jniId) :
			id (userDefinedId),
			jid (jniId) {}
	};
	typedef std::map<int, JMethod*> MethodMap;

	const std::string JAVA_CLASS_PATH;
	MethodMap methods;
};

#endif /* JNIHELPER_H_ */
