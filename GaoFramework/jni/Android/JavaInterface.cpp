#include "JavaInterface.h"
#include "Java/JniEnv.h"
#include <string>

static const char JAVA_CLASS_PATH[]                    = "com/studioirregular/gaoframework/JavaInterface";
static const char METHOD_NAME_GET_INSTANCE[]           = "getInstance";
static const char METHOD_DESCRIPTOR_GET_INSTANCE[]     = "()Lcom/studioirregular/gaoframework/JavaInterface;";
static const char METHOD_NAME_POP_TOUCH_EVENTS[]       = "popTouchEvents";
static const char METHOD_DESCRIPTOR_POP_TOUCH_EVENTS[] = "()[Lcom/studioirregular/gaoframework/TouchEvent;";
static const char METHOD_NAME_GET_LOG_FILE_PATH[]      = "getLogFilePath";
static const char METHOD_DESCRIPTOR_GET_LOG_FILE_PATH[]= "()Ljava/lang/String;";
static const char METHOD_NAME_DRAW[]                   = "draw";
static const char METHOD_DESCRIPTOR_DRAW[]             = "(Lcom/studioirregular/gaoframework/Rectangle;)V";
static const char METHOD_NAME_GET_ASSET_FILE_FOLDER[]  = "GetAssetFileFolder";
static const char METHOD_DESCRIPTOR_GET_ASSET_FILE_FOLDER[]= "()Ljava/lang/String;";


JavaInterface::JavaInterface() :
	jobj (JAVA_CLASS_PATH),
	log ("native::framework::JavaInterface", false) {

	LOGD(log, "JavaInterface")

	JavaClass* jclass = jobj.GetClass();
	if (jclass == NULL) {
		LOGE(log, "JavaInterface cannot find class:%s", JAVA_CLASS_PATH)
		return;
	}

	jobject obj = jclass->CallStaticObjectMethod(METHOD_NAME_GET_INSTANCE, 
		METHOD_DESCRIPTOR_GET_INSTANCE);

	if (obj == NULL) {
		LOGE(log, "JavaInterface got NULL return from method:%s, descriptor:%s", 
			METHOD_NAME_GET_INSTANCE, METHOD_DESCRIPTOR_GET_INSTANCE)
		return;
	}

	jobj.SetJavaRef(obj);
}

JavaInterface::~JavaInterface() {
}

TouchEventArray* JavaInterface::GetTouchEvents() {

	TouchEventArray* result = new TouchEventArray();

	jobjectArray jarr = (jobjectArray)jobj.CallObjectMethod(
		METHOD_NAME_POP_TOUCH_EVENTS, METHOD_DESCRIPTOR_POP_TOUCH_EVENTS);

	JNIEnv* env = g_JniEnv->Get();

	const jsize SIZE = env->GetArrayLength(jarr);
	for (jsize i = 0; i < SIZE; i++) {
		jobject jevent = env->GetObjectArrayElement(jarr, i);

		TouchEvent* event = new TouchEvent(jevent);

		// delete local reference to prevent JNI local reference table overflow.
		env->DeleteLocalRef(jevent);

		result->Add(event);
	}

	return result;
}

char* JavaInterface::GetLogFilePath() {

	LOGD(log, "GetLogFilePath")

	JNIEnv* env = g_JniEnv->Get();

	jstring jstrPath = (jstring)jobj.CallObjectMethod(METHOD_NAME_GET_LOG_FILE_PATH, 
		METHOD_DESCRIPTOR_GET_LOG_FILE_PATH);
	if (jstrPath == NULL) {
		LOGE(log, "GetLogFilePath: CallObjectMethod return NULL")
		return NULL;
	}
	const char* cstrPath = env->GetStringUTFChars(jstrPath, NULL);

	char* result = new char[std::strlen(cstrPath) + 1];
	std::strcpy(result, cstrPath);
	LOGD(log, "GetLogFilePath path:%s", result)

	env->ReleaseStringUTFChars(jstrPath, cstrPath);

	return result;
}

char* JavaInterface::GetAssetFileFolder() {

	LOGD(log, "GetAssetFileFolder")

	JNIEnv* env = g_JniEnv->Get();

	jstring jstrPath = (jstring)jobj.CallObjectMethod(
		METHOD_NAME_GET_ASSET_FILE_FOLDER, METHOD_DESCRIPTOR_GET_ASSET_FILE_FOLDER);
	if (jstrPath == NULL) {
		LOGE(log, "GetAssetFileFolder: CallObjectMethod return NULL")
		return NULL;
	}
	const char* cstrPath = env->GetStringUTFChars(jstrPath, NULL);

	char* result = new char[std::strlen(cstrPath) + 1];
	std::strcpy(result, cstrPath);
	LOGD(log, "GetAssetFileFolder path:%s", result)

	env->ReleaseStringUTFChars(jstrPath, cstrPath);

	return result;
}

void JavaInterface::Draw(Rectangle* rect) {
	jobj.CallVoidMethod(METHOD_NAME_DRAW, METHOD_DESCRIPTOR_DRAW, rect->GetJavaRef());
}

void JavaInterface::DrawRectangle(
	GaoInt16 left, GaoInt16 top, GaoInt16 right, GaoInt16 bottom, 
	float red, float green, float blue, float alpha) {
	
	jobj.CallVoidMethod("DrawRectangle", "(IIIIFFFF)V", 
		left, top, right, bottom, red, green, blue, alpha);
}