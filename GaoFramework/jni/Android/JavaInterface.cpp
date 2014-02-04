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
static const char METHOD_NAME_DRAW_RECTANGLE[]         = "DrawRectangle";
static const char METHOD_DESCRIPTOR_DRAW_RECTANGLE[]   = "(IIIIFFFF)V";
static const char METHOD_NAME_DRAW_CIRCLE[]            = "DrawCircle";
static const char METHOD_DESCRIPTOR_DRAW_CIRCLE[]      = "(FFFFFFF)V";


JavaInterface::JavaInterface() :
	jobj (JAVA_CLASS_PATH),
	log ("native::framework::JavaInterface", true) {

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

void JavaInterface::DrawRectangle(
	GaoInt16 left, GaoInt16 top, GaoInt16 right, GaoInt16 bottom, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {
	
	jobj.CallVoidMethod(METHOD_NAME_DRAW_RECTANGLE, METHOD_DESCRIPTOR_DRAW_RECTANGLE, 
		left, top, right, bottom, red, green, blue, alpha);
}

void JavaInterface::DrawCircle(
	GaoReal32 x, GaoReal32 y, GaoReal32 radius, 
	GaoReal32 red, GaoReal32 green, GaoReal32 blue, GaoReal32 alpha) {
	
	jobj.CallVoidMethod(METHOD_NAME_DRAW_CIRCLE, METHOD_DESCRIPTOR_DRAW_CIRCLE, 
		x, y, radius, red, green, blue, alpha);
}

void JavaInterface::TestFlightPassCheckpoint(const char* msg) {
	
	LOGD(log, "TestFlightPassCheckpoint msg:%s", msg)

	jstring jmsg = g_JniEnv->NewStringUTF(msg);

	jobj.CallVoidMethod("TestFlightPassCheckpoint", "(Ljava/lang/String;)V", jmsg);
}

void JavaInterface::NotifyBackProcessResult(GaoBool consumed) {

	LOGD(log, "NotifyBackProcessResult consumed:%d", consumed)

	jobj.CallVoidMethod("NotifyBackProcessResult", "(Z)V", consumed);
}

const char* JavaInterface::GetString(const char* name) {

	LOGD(log, "GetString name:%s", name)

	JNIEnv* env = g_JniEnv->Get();
	jstring jname = name != NULL ? env->NewStringUTF(name) : NULL;

	jstring jstr = (jstring)jobj.CallObjectMethod("GetString", "(Ljava/lang/String;)Ljava/lang/String;", name);
	if (jname != NULL)   env->DeleteLocalRef(jname);

	if (jstr == NULL) {
		LOGE(log, "GetString failed to get string with name:%s", name)
		return name;
	}

	const char* str = env->GetStringUTFChars(jstr, NULL);

	if (str == NULL) {
		LOGE(log, "GetString GetStringUTFChars returns NULL")
		return name;
	}

	char* result = new char[std::strlen(str) + 1];
	std::strcpy(result, str);

	env->ReleaseStringUTFChars(jstr, str);
	return result;
}

void JavaInterface::ShowMessage(const char* title, const char* message, const char* button) {

	LOGD(log, "ShowMessage title:%s, message:%s, button:%s", title, message, button)

	JNIEnv* env = g_JniEnv->Get();

	jstring jtitle   = title != NULL ?   env->NewStringUTF(title) : NULL;
	jstring jmessage = message != NULL ? env->NewStringUTF(message) : NULL;
	jstring jbutton  = button != NULL ?  env->NewStringUTF(button) : NULL;

	jobj.CallVoidMethod("ShowDialog", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", jtitle, jmessage, jbutton);

	if (jtitle != NULL)   env->DeleteLocalRef(jtitle);
	if (jmessage != NULL) env->DeleteLocalRef(jmessage);
	if (jbutton != NULL)  env->DeleteLocalRef(jbutton);
}
