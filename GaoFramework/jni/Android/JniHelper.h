#ifndef JNIHELPER_H_
#define JNIHELPER_H_

#include <jni.h>
#include <map>
#include <string>

class JniHelper {

public:
	JniHelper(const char* classPath);
	virtual ~JniHelper();

	jobject NewObject(JNIEnv* env, const char* ctorDescriptor, ...);
	bool AddMethod(JNIEnv* env, int id, const char* name, const char* descriptor);
	jmethodID GetMethod(int id);

private:
	struct JMethod {
		int id;
		const std::string name;
		const std::string descriptor;
		jmethodID jid;

		JMethod(int userDefinedId, const char* methodName, const char* methodDescriptor, 
			jmethodID jniId) :
			id (userDefinedId),
			name (methodName),
			descriptor (methodDescriptor),
			jid (jniId) {}
	};
	typedef std::map<int, JMethod*> MethodMap;

	const std::string JAVA_CLASS_PATH;
	MethodMap methods;
};

#endif /* JNIHELPER_H_ */
