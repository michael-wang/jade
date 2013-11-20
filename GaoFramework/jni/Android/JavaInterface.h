#ifndef JAVAINTERFACE_H_
#define JAVAINTERFACE_H_

#include <jni.h>
#include <Framework/DataType.hpp>
#include <Framework/Singleton.hpp>
#include "Java/JavaObject.h"
#include "Rectangle.h"
#include "TouchEvent.h"
#include "AndroidLogger.h"

class JavaInterface : public Gao::Framework::Singleton<JavaInterface>  {

public:
	JavaInterface();
	virtual ~JavaInterface();

	TouchEventArray* GetTouchEvents();
	char* GetLogFilePath();

	void Draw(Rectangle* rect);
	
private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* JAVAINTERFACE_H_ */