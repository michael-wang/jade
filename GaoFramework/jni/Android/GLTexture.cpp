#include "GLTexture.h"
#include "Java/JniEnv.h"
#include <android/log.h>


static const char TAG[] = "native::framework::GLTexture";

static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/GLTexture";
static const char JAVA_CONSTRUCTOR_DESCRIPTOR[] = "()V";
static const char JAVA_INTERFACE_PATH[]			= "com/studioirregular/gaoframework/JavaInterface";
static const char JAVA_CREATE_NAME[]            = "Create";
static const char JAVA_CREATE_DESCRIPTOR[]      = "(Ljava/lang/String;)Z";

GLTexture::GLTexture() :
	jobj (JAVA_CLASS_PATH, JAVA_CONSTRUCTOR_DESCRIPTOR) {

	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Constructor");
}

GLTexture::~GLTexture() {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Destructor");
}

GaoBool GLTexture::Create(GaoString& fileName) {
	__android_log_print(ANDROID_LOG_DEBUG, TAG, "Create fileName:%s", 
		fileName.c_str());

	jstring jfilename = g_JniEnv->NewStringUTF(fileName.c_str());
	jboolean success = jobj.CallBooleanMethod(
		JAVA_CREATE_NAME, JAVA_CREATE_DESCRIPTOR, jfilename);

	return success;
}

GaoBool GLTexture::Reload() {
	return FALSE;
}

GaoVoid GLTexture::Unload() {
}
