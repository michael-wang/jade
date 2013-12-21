#include "AndroidFileSystem.h"
#include "AndroidLogger.h"
#include "Java/JniEnv.h"


static const bool DEBUG_LOG = false;
static const char CLASS_PATH[]  = "com/studioirregular/gaoframework/AndroidFileSystem";

AndroidFileSystem::AndroidFileSystem() {
}

AndroidFileSystem::~AndroidFileSystem() {
}

GaoVoid AndroidFileSystem::MakeFullPath(GaoString& fileName) {

	AndroidLogger log("native::framework::AndroidFileSystem", DEBUG_LOG);
	LOGD(log, "MakeFullPath fileName:%s", fileName.c_str())

	JavaClass* clazz = g_JniEnv->FindClass(CLASS_PATH);
	if (clazz == NULL) {
		LOGE(log, "MakeFullPath: Cannot find class:%s", CLASS_PATH)
		return;
	}

	jstring arg = g_JniEnv->NewStringUTF(fileName.c_str());
	jstring result = (jstring) clazz->CallStaticObjectMethod("MakeFullPath", 
		"(Ljava/lang/String;)Ljava/lang/String;", arg);

	if (result != NULL) {
		const char* resultChars = g_JniEnv->GetStringUTFChars(result, NULL);

		fileName = resultChars;
		LOGD(log, "result fileName:%s", fileName.c_str())

		g_JniEnv->ReleaseStringUTFChars(result, resultChars);
	}
}

GaoConstCharPtr AndroidFileSystem::MakeDocumentPath(GaoConstCharPtr fileName) {

	AndroidLogger log("native::framework::AndroidFileSystem", DEBUG_LOG);
	LOGD(log, "MakeDocumentPath fileName:%s", fileName)

	JavaClass* clazz = g_JniEnv->FindClass(CLASS_PATH);
	if (clazz == NULL) {
		LOGE(log, "MakeDocumentPath: Cannot find class:%s", CLASS_PATH)
		return fileName;
	}

	jstring arg = g_JniEnv->NewStringUTF(fileName);
	jstring jpath = (jstring) clazz->CallStaticObjectMethod("MakeDocumentPath", 
		"(Ljava/lang/String;)Ljava/lang/String;", arg);

	const char* pathChars = g_JniEnv->GetStringUTFChars(jpath, NULL);

	GaoString result = (pathChars == NULL ? fileName : pathChars);
	g_JniEnv->ReleaseStringUTFChars(jpath, pathChars);

	LOGD(log, "result:%s", result.c_str())

	return result.c_str();
}