#include <jni.h>
#include "com_studioirregular_jadeninja_p1_MainActivity.h"
#include <android/log.h>
#include <Framework/LuaScriptManager.hpp>

using namespace Gao::Framework;

static LuaScriptManager* mgr;

void Java_com_studioirregular_jadeninja_p1_MainActivity_nativeCreate
	(JNIEnv *jenv, jobject clazz) {
	__android_log_print(ANDROID_LOG_INFO, "jade-ninja", "nativeCreate");

	mgr = new LuaScriptManager();
	mgr->Create();
}

void Java_com_studioirregular_jadeninja_p1_MainActivity_nativeDestroy
	(JNIEnv *jenv, jobject clazz) {
	;__android_log_print(ANDROID_LOG_INFO, "jade-ninja", "nativeDestroy");

	SAFE_DELETE(mgr);
}
