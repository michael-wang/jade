#include "GLTexture.h"
#include "Java/JniEnv.h"


static const char JAVA_CLASS_PATH[]				= "com/studioirregular/gaoframework/gles/Texture";
static const char JAVA_CONSTRUCTOR_DESCRIPTOR[] = "()V";
static const char JAVA_INTERFACE_PATH[]			= "com/studioirregular/gaoframework/JavaInterface";
static const char JAVA_CREATE_NAME[]            = "Create";
static const char JAVA_CREATE_DESCRIPTOR[]      = "(Ljava/lang/String;Z)Z";

GLTexture::GLTexture() :
	jobj (JAVA_CLASS_PATH, JAVA_CONSTRUCTOR_DESCRIPTOR),
	log ("native::framework::GLTexture", false) {

	LOGD(log, "Constructor")
}

GLTexture::~GLTexture() {
	LOGD(log, "Destructor")
}

GaoBool GLTexture::Create(GaoString& fileName) {
	return Create(fileName, false);
}

GaoBool GLTexture::Create(GaoString& fileName, GaoBool filtered) {
	LOGD(log, "Create fileName:%s, filtered:%d", fileName.c_str(), filtered)

	jstring jfilename = g_JniEnv->NewStringUTF(fileName.c_str());
	jboolean success = jobj.CallBooleanMethod(
		JAVA_CREATE_NAME, JAVA_CREATE_DESCRIPTOR, jfilename, filtered);

	return success;
}

GaoBool GLTexture::Reload() {
	LOGD(log, "Reload")

	return jobj.CallBooleanMethod("Reload", "()Z");
}

GaoVoid GLTexture::Unload() {
	LOGD(log, "Unload")

	jobj.CallVoidMethod("Unload", "()V");
}
