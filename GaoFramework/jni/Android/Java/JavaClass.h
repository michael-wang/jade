#ifndef JAVACLASS_H_
#define JAVACLASS_H_

#include <jni.h>
#include <string>


class JavaClass {

public:
	/*
	 * path: full qualitied class path.
	 */
	JavaClass(const char* path);

	virtual ~JavaClass();

	jclass GetClassRef() {
		return classRef;
	}

	jmethodID GetMethodID(const char* name, const char* descriptor);

	jobject CallStaticObjectMethod(const char* name, const char* descriptor, ...);

public:
	static const char* CONSTRUCTOR_METHOD_NAME;

private:
	const std::string CLASS_PATH;
	jclass classRef;
};

#endif /* JAVACLASS_H_ */