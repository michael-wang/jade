#ifndef JAVAINTERFACE_H_
#define JAVAINTERFACE_H_

#include <jni.h>
#include "TouchEvent.h"

class JavaInterface {

public:
	JavaInterface();
	virtual ~JavaInterface();

	TouchEventArray* GetTouchEvents();
	
private:
	jobject javaRef;
};

#endif /* JAVAINTERFACE_H_ */