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
	char* GetAssetFileFolder();

	void Draw(Rectangle* rect);
	
	void DrawRectangle(
		GaoInt16 left, GaoInt16 top, GaoInt16 right, GaoInt16 bottom, 
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

	void DrawCircle(GaoReal32 x, GaoReal32 y, GaoReal32 radius,
		GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha);

private:
	JavaObject jobj;
	AndroidLogger log;
};

#endif /* JAVAINTERFACE_H_ */