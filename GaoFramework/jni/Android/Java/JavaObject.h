#ifndef JAVAOBJECT_H_
#define JAVAOBJECT_H_

#include "JavaClass.h"


class JavaObject {

public:
	/*
	 * classPath: full qualified class path.
	 * constructor: descriptor, e.g. "(I)V" for constructor with one integer parameter.
	 * ...: constructor parameters.
	 */
	JavaObject(const char* classPath, const char* constructor, ...);

	virtual ~JavaObject();

	jobject GetJavaRef() {
		return javaRef;
	}

	void CallVoidMethod(const char* name, const char* descriptor, ...);
	bool CallBooleanMethod(const char* name, const char* descriptor, ...);

private:
	JavaClass* clazz;
	jobject javaRef;
};

#endif /* JAVAOBJECT_H_ */