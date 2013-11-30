#ifndef JAVAOBJECT_H_
#define JAVAOBJECT_H_

#include "JavaClass.h"
#include <Android/AndroidLogger.h>


class JavaObject {

public:
	/*
	 * classPath: full qualified class path.
	 * constructor: descriptor, e.g. "(I)V" for constructor with one integer parameter.
	 * ...: constructor parameters.
	 */
	JavaObject(const char* classPath, const char* constructor, ...);
	JavaObject(const char* classPath);

	virtual ~JavaObject();

	jobject GetJavaRef() {
		return javaRef;
	}

	void SetJavaRef(jobject ref);

	JavaClass* GetClass() {
		return clazz;
	}

	void CallVoidMethod(const char* name, const char* descriptor, ...) const;
	bool CallBooleanMethod(const char* name, const char* descriptor, ...) const;
	jobject CallObjectMethod(const char* name, const char* descriptor, ...) const;
	jfloat CallFloatMethod(const char* name, const char* descriptor, ...) const;

private:
	JavaClass* const clazz;
	jobject javaRef;
	AndroidLogger log;
};

#endif /* JAVAOBJECT_H_ */