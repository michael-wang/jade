#ifndef JAVAINTERFACE_H_
#define JAVAINTERFACE_H_

#include <jni.h>
#include "Java/JavaObject.h"
#include "TouchEvent.h"

class JavaInterface {

public:
	JavaInterface();
	virtual ~JavaInterface();

	TouchEventArray* GetTouchEvents();
	char* GetLogFilePath();
	
private:
	JavaObject* jobj;
};

#endif /* JAVAINTERFACE_H_ */